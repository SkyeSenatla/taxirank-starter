# Progress

## What works in this implementation

- Unknown server statuses map to `QueueStatus.unknown` and display as words.
- Queue state is keyed by route id; board uses the server-returned taxi and does not add a second fare.
- Queue empty/failure/not-found states have messages and retry where appropriate.
- Taxi detail is addressed by route and taxi ids and fetches from the repository.
- Status colours are supplied by the app theme extension for light and dark themes.
- Departures have a domain model, repository boundary, provider and screen; server order, passenger count and takings are retained, and UTC instants are displayed in local time.

## What still needs verification

- Run the generated-code build, analyzer and full test suite in the target Codespace.
- Review any SDK-specific analyzer diagnostics. CI is pinned to Flutter 3.47.7; use that version for a like-for-like CI result.
- Add/expand widget and repository tests for retry recovery, cross-route isolation, deep links, departure empty/failure and dark-theme status colours.
- Verify the deep-link intent filter and the required seeded examples on a device/emulator.

## What I copied, and what I changed

No external project files were copied in this pass. Existing TaxiRank structure and server contract were retained. The implementation adds a route-keyed queue notifier, taxi detail route/repository lookup, and the departures model/repository/provider/screen.

## Boundaries

- Kept `lib/core/fakes/` unchanged: the server remains the source of truth for queue order, fares, positions and departure takings.
- Kept `test/support/harness.dart` unchanged: the shared test setup remains available to assessment tests.
- Kept the name `appRetryPolicy`.
- Boundary to remove: none recommended; these boundaries prevent the UI from duplicating backend rules.

## What I'd do next

Run all four required CI commands, fix any diagnostics, and add the missing focused widget and repository tests before hand-in.
