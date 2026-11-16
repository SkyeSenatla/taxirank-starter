# TaxiRank

A rank marshal's app for Bree Street taxi rank, Johannesburg. The marshal
watches each route's queue, boards passengers on the taxi that is loading,
sends full taxis off, and looks back over today's departures.

Week 10 revision challenge starter. The brief is handed out in class.

## Running it

Flutter **3.47.7** (Dart 3.13.5), the same as the Week 10 demo.

```
flutter pub get
dart run build_runner build      # first run compiles builders: about 2 minutes
flutter run                      # on the emulator
```

The four CI steps, in CI's order:

```
dart format --output=none --set-exit-if-changed .
dart run build_runner build
dart analyze --fatal-infos
flutter test
```

Deep links use the scheme `taxirank`, host `app`. With the app closed:

```
adb shell am start -a android.intent.action.VIEW -d "taxirank://app/queues/soweto"
```

## The backend: `lib/core/fakes/rank_server.dart`

There is no network. `RankServer` plays the API's part, in memory, behind
`rankServerProvider`. **Don't edit `lib/core/fakes/`**: work with the server
as it is, the way you would with someone else's API. It answers in wire form
(`Map<String, Object?>` and lists of them, as decoded JSON would be), and
every call takes 500 ms. Restarting the app resets its data.

| Call | Answers |
| --- | --- |
| `getRoutes()` | Every route: `id`, `name`, `fareCents`, `queueLength` |
| `getQueue(routeId)` | `routeId`, `routeName`, `fareCents`, `capacity` (15), and `taxis` in queue order. An unknown route: `RankNotFound` |
| `getTaxi(routeId, taxiId)` | One taxi, plus `routeId`, `routeName` and `capacity`. A taxi that isn't on that route: `RankNotFound` |
| `board(routeId, taxiId)` | One passenger boards and pays the fare. Returns the taxi as the server now has it. Only a `Loading` taxi: otherwise `RankConflict` |
| `depart(routeId, taxiId)` | A `Full` taxi leaves: it becomes today's newest departure, and the next waiting taxi starts loading. Returns the departure. Otherwise `RankConflict` |
| `getDepartures()` | Today's departures, newest first |

A taxi in the wire form:

| Field | Type | Notes |
| --- | --- | --- |
| `id` | String | `tx-102` |
| `registration` | String | `GP 228-310` |
| `driverName` | String | |
| `status` | String | `Waiting`, `Loading` or `Full`, exactly so. The server may send others |
| `seatsTaken` | int | 0 to `capacity` |
| `collectedCents` | int | What the taxi has collected so far. **The server adds each fare** |
| `position` | int | 1 is the front of the queue |

A departure: `id`, `taxiId`, `registration`, `routeId`, `routeName`,
`departedAt` (an ISO 8601 instant in **UTC**), `passengers`, `takingsCents`.

Errors (`lib/core/errors/rank_errors.dart`) are `RankNotFound` (404),
`RankConflict` (409) and `RankUnavailable` (503). Each has a `message` and a
`reference` the marshal can quote.

### The seed data

| Route | Fare | Queue |
| --- | --- | --- |
| `soweto`, Bree to Bara (Soweto) | R 18,50 | tx-101 Full, tx-102 Loading (12 of 15), tx-103 Waiting |
| `alex`, Bree to Alexandra | R 16,00 | tx-201 Loading (4 of 15), tx-202, tx-203 Waiting |
| `tembisa`, Bree to Tembisa | R 24,00 | tx-301 Loading (9 of 15), tx-302 Waiting. **Its network is down for its first four queue requests** |
| `randburg`, Bree to Randburg | R 17,50 | No taxis |

## Rules for this repo

- Don't edit `lib/core/fakes/` or `test/support/harness.dart`.
- `test/support/harness.dart` pumps the whole app the way `main()` does. Use
  it in your widget tests; your instructor's checks use it too.
- Keep the name of `appRetryPolicy` in `lib/app/retry_policy.dart`.
- Work on your own branch. Never push to `main`.
