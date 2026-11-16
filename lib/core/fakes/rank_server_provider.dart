import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taxirank/core/fakes/rank_server.dart';

part 'rank_server_provider.g.dart';

/// The one rank server for the whole app. Tests override it with their own.
/// Don't edit this file.
@Riverpod(keepAlive: true)
RankServer rankServer(Ref ref) => RankServer();
