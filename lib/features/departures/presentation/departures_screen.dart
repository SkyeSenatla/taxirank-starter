import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:taxirank/core/errors/rank_errors.dart';
import 'package:taxirank/core/money/format_rands.dart';
import 'package:taxirank/features/departures/presentation/departures_provider.dart';

/// Today's departures from the rank.
class DeparturesScreen extends ConsumerWidget {
  /// Creates the screen.
  const DeparturesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final departures = ref.watch(todayDeparturesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Departures')),
      body: departures.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                e is RankError
                    ? "We couldn't load today's departures."
                    : "We couldn't load today's departures.",
              ),
              if (e is RankError) Text('Reference: ${e.reference}'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.invalidate(todayDeparturesProvider),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
        data: (items) => items.isEmpty
            ? const Center(child: Text('No departures yet today.'))
            : ListView(
                children: [
                  for (final d in items)
                    ListTile(
                      title: Text(d.registration),
                      subtitle: Text(
                        '${d.routeName} · ${DateFormat('HH:mm').format(d.departedAt.toLocal())} · ${d.passengers} passengers',
                      ),
                      trailing: Text(formatRands(d.takings)),
                    ),
                ],
              ),
      ),
    );
  }
}
