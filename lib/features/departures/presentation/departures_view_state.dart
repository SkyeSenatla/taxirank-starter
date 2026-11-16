import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxirank/core/errors/rank_errors.dart';
import 'package:taxirank/features/departures/domain/departure.dart';

/// Exhaustive presentation states for Departures.
sealed class DeparturesViewState {
  const DeparturesViewState();
}

/// Loading.
final class DeparturesLoading extends DeparturesViewState {
  const DeparturesLoading();
}

/// No departures today.
final class DeparturesEmpty extends DeparturesViewState {
  const DeparturesEmpty();
}

/// Successfully fetched departures.
final class DeparturesData extends DeparturesViewState {
  const DeparturesData(this.items);
  final List<Departure> items;
}

/// Request failed; expose the server's reference if available.
final class DeparturesFailure extends DeparturesViewState {
  const DeparturesFailure(this.error);
  final Object error;

  String? get reference => switch (error) {
    RankError(:final reference) => reference,
    _ => null,
  };
}

/// Converts Riverpod's async state to a finite set of screen states.
DeparturesViewState departuresViewState(AsyncValue<List<Departure>> value) =>
    switch (value) {
      AsyncData(value: final items) when items.isEmpty =>
        const DeparturesEmpty(),
      AsyncData(value: final items) => DeparturesData(items),
      AsyncError(:final error) => DeparturesFailure(error),
      _ => const DeparturesLoading(),
    };
