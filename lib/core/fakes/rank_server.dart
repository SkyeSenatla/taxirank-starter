// THE BACKEND. Don't edit this file: it plays the part an API plays, and
// your app must work with it as it is. Read README.md for its contract.
//
// It answers in "wire" form, Map and List values shaped like JSON, the way
// an HTTP client would hand you a decoded response. Turning those into your
// own types is your app's job.

import 'package:taxirank/core/errors/rank_errors.dart';

/// Bree Street taxi rank's server, in memory.
final class RankServer {
  /// Creates the server with its seed data.
  ///
  /// [latency] is the pretend network time for every call, and
  /// [queueLatency] adds more for one route's queue. Tembisa's network is
  /// down for its first [tembisaFailures] queue requests. [departures]
  /// replaces today's departures; [departuresDown] makes them fail.
  new({
    this.latency = const Duration(milliseconds: 500),
    this.queueLatency = const {},
    this.tembisaFailures = 4,
    List<Map<String, Object?>>? departures,
    this.departuresDown = false,
  }) : _departures = [...(departures ?? _seedDepartures())];

  /// How long every call takes.
  final Duration latency;

  /// Extra time for one route's queue, by route id.
  final Map<String, Duration> queueLatency;

  /// How many of Tembisa's queue requests fail before it comes back.
  final int tembisaFailures;

  /// Whether today's departures fail to load.
  final bool departuresDown;

  final List<Map<String, Object?>> _departures;
  final Map<String, List<Map<String, Object?>>> _queues = _seedQueues();
  int _tembisaCalls = 0;
  int _requests = 0;

  String _reference() => 'TR-${(++_requests).toString().padLeft(5, '0')}';

  /// GET /routes: every route from the rank, with its fare and queue length.
  Future<List<Map<String, Object?>>> getRoutes() async {
    await Future<void>.delayed(latency);
    return [
      for (final route in _routes)
        {...route, 'queueLength': _queues[route['id']]!.length},
    ];
  }

  /// GET /routes/{routeId}/queue: the route and its taxis, in queue order.
  Future<Map<String, Object?>> getQueue(String routeId) async {
    await Future<void>.delayed(
      latency + (queueLatency[routeId] ?? Duration.zero),
    );
    final route = _route(routeId);
    if (routeId == 'tembisa' && _tembisaCalls++ < tembisaFailures) {
      throw RankUnavailable(
        "The rank's network is down. Try again in a moment.",
        _reference(),
      );
    }
    return {
      'routeId': route['id'],
      'routeName': route['name'],
      'fareCents': route['fareCents'],
      'capacity': capacity,
      'taxis': [
        for (final taxi in _queues[routeId]!) {...taxi},
      ],
    };
  }

  /// GET /routes/{routeId}/taxis/{taxiId}: one taxi, with its route and the
  /// seats in it, only if it is on that route's queue.
  Future<Map<String, Object?>> getTaxi(String routeId, String taxiId) async {
    await Future<void>.delayed(latency);
    final route = _route(routeId);
    return {
      ..._taxi(routeId, taxiId),
      'routeId': route['id'],
      'routeName': route['name'],
      'capacity': capacity,
    };
  }

  /// POST /routes/{routeId}/taxis/{taxiId}/board: one passenger boards and
  /// pays the route's fare. The taxi must be Loading. Returns the taxi.
  Future<Map<String, Object?>> board(String routeId, String taxiId) async {
    await Future<void>.delayed(latency);
    final route = _route(routeId);
    final taxi = _taxi(routeId, taxiId);
    if (taxi['status'] != 'Loading') {
      throw RankConflict(
        'Only a taxi that is loading can take passengers.',
        _reference(),
      );
    }
    final seats = (taxi['seatsTaken']! as int) + 1;
    taxi['seatsTaken'] = seats;
    taxi['collectedCents'] =
        (taxi['collectedCents']! as int) + (route['fareCents']! as int);
    if (seats == capacity) taxi['status'] = 'Full';
    return {...taxi};
  }

  /// POST /routes/{routeId}/taxis/{taxiId}/depart: a full taxi leaves. It
  /// becomes today's newest departure, and the next waiting taxi starts
  /// loading. Returns the departure.
  Future<Map<String, Object?>> depart(String routeId, String taxiId) async {
    await Future<void>.delayed(latency);
    final route = _route(routeId);
    final taxi = _taxi(routeId, taxiId);
    if (taxi['status'] != 'Full') {
      throw RankConflict('Only a full taxi can depart.', _reference());
    }
    final queue = _queues[routeId]!..remove(taxi);
    for (final (i, t) in queue.indexed) {
      t['position'] = i + 1;
    }
    final next = queue.where((t) => t['status'] == 'Waiting').firstOrNull;
    if (next != null && !queue.any((t) => t['status'] == 'Loading')) {
      next['status'] = 'Loading';
    }
    final departure = {
      'id': 'dp-${_departures.length + 1}',
      'taxiId': taxi['id'],
      'registration': taxi['registration'],
      'routeId': route['id'],
      'routeName': route['name'],
      'departedAt': DateTime.now().toUtc().toIso8601String(),
      'passengers': taxi['seatsTaken'],
      'takingsCents': taxi['collectedCents'],
    };
    _departures.insert(0, departure);
    return {...departure};
  }

  /// GET /departures/today: today's departures, newest first.
  Future<List<Map<String, Object?>>> getDepartures() async {
    await Future<void>.delayed(latency);
    if (departuresDown) {
      throw RankUnavailable(
        "Today's departures can't be loaded right now.",
        _reference(),
      );
    }
    return [
      for (final d in _departures) {...d},
    ];
  }

  Map<String, Object?> _route(String routeId) {
    for (final route in _routes) {
      if (route['id'] == routeId) return route;
    }
    throw RankNotFound('No route $routeId.', _reference());
  }

  Map<String, Object?> _taxi(String routeId, String taxiId) {
    for (final taxi in _queues[routeId]!) {
      if (taxi['id'] == taxiId) return taxi;
    }
    // A taxi on another route is "not found" too, as an API's 404 would be.
    throw RankNotFound('No taxi $taxiId on this route.', _reference());
  }

  /// Seats in every taxi.
  static const capacity = 15;

  static const List<Map<String, Object?>> _routes = [
    {'id': 'soweto', 'name': 'Bree to Bara (Soweto)', 'fareCents': 1850},
    {'id': 'alex', 'name': 'Bree to Alexandra', 'fareCents': 1600},
    {'id': 'tembisa', 'name': 'Bree to Tembisa', 'fareCents': 2400},
    {'id': 'randburg', 'name': 'Bree to Randburg', 'fareCents': 1750},
  ];

  static Map<String, List<Map<String, Object?>>> _seedQueues() => {
    'soweto': [
      _t('tx-101', 'GP 412-871', 'Mandla Zwane', 'Full', 15, 27750, 1),
      _t('tx-102', 'GP 228-310', 'Busisiwe Nkosi', 'Loading', 12, 22200, 2),
      _t('tx-103', 'GP 905-144', 'Kagiso Molefe', 'Waiting', 0, 0, 3),
    ],
    'alex': [
      _t('tx-201', 'GP 330-512', 'Thabo Mahlangu', 'Loading', 4, 6400, 1),
      // A status this version of the server sends, and your app may not know.
      _t('tx-202', 'GP 117-406', 'Zanele Khoza', 'OffDuty', 0, 0, 2),
      _t('tx-203', 'GP 751-093', 'Sello Maseko', 'Waiting', 0, 0, 3),
    ],
    'tembisa': [
      _t('tx-301', 'GP 864-275', 'Precious Ndlovu', 'Loading', 9, 21600, 1),
      _t('tx-302', 'GP 503-618', 'Lungile Shabalala', 'Waiting', 0, 0, 2),
    ],
    'randburg': [],
  };

  static Map<String, Object?> _t(
    String id,
    String registration,
    String driver,
    String status,
    int seats,
    int collected,
    int position,
  ) => {
    'id': id,
    'registration': registration,
    'driverName': driver,
    'status': status,
    'seatsTaken': seats,
    'collectedCents': collected,
    'position': position,
  };

  static List<Map<String, Object?>> _seedDepartures() => [
    {
      'id': 'dp-3',
      'taxiId': 'tx-099',
      'registration': 'GP 640-221',
      'routeId': 'soweto',
      'routeName': 'Bree to Bara (Soweto)',
      'departedAt': '2026-11-17T06:42:00Z',
      'passengers': 15,
      'takingsCents': 27750,
    },
    {
      'id': 'dp-2',
      'taxiId': 'tx-198',
      'registration': 'GP 372-905',
      'routeId': 'alex',
      'routeName': 'Bree to Alexandra',
      'departedAt': '2026-11-17T06:20:00Z',
      'passengers': 15,
      'takingsCents': 24000,
    },
    {
      'id': 'dp-1',
      'taxiId': 'tx-297',
      'registration': 'GP 185-447',
      'routeId': 'tembisa',
      'routeName': 'Bree to Tembisa',
      'departedAt': '2026-11-17T05:58:00Z',
      'passengers': 15,
      'takingsCents': 36000,
    },
  ];
}
