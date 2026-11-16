import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxirank/core/money/format_rands.dart';
import 'package:taxirank/features/departures/presentation/departures_provider.dart';
import 'package:taxirank/features/departures/presentation/departures_view_state.dart';

/// Today's departures, rendered without calculating any money or positions.
class DeparturesScreen extends ConsumerWidget {
  /// Creates the Departures tab.
  const DeparturesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = departuresViewState(ref.watch(departuresProvider));
    return Scaffold(
      appBar: AppBar(title: const Text('Departures')),
      body: switch (state) {
        DeparturesLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        DeparturesEmpty() => const Center(
          child: Text('No departures yet today.'),
        ),
        DeparturesFailure(:final reference) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("We couldn't load today's departures."),
              if (reference != null) Text('Reference: $reference'),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(departuresProvider),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
        DeparturesData(:final items) => ListView(
          padding: const EdgeInsets.all(12),
          children: [
            for (final departure in items)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.local_taxi_outlined),
                  title: Text(departure.registration),
                  subtitle: Text(
                    '${departure.routeName} · ${departure.southAfricanTime} '
                    '· ${departure.passengers} passengers',
                  ),
                  trailing: Text(formatRands(departure.takings)),
                ),
              ),
          ],
        ),
      },
    );
  }
}
