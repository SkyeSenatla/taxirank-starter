# Progress — TaxiRank Week 10 revision

## What was implemented in this working copy

- Explicit unknown queue status; exhaustive status labels and taxi actions.
- One Riverpod queue family per route ID; no shared selected queue state.
- Boarding uses the server's returned `collectedCents` without adding fare twice; duplicate button taps are guarded.
- Separate 404 versus retryable failure/empty/loading/data states; queue retry and reference display.
- Typed taxi details address using IDs only, with a taxi-not-found state.
- Theme extension with light/dark status colours; responsive rail from 600dp.
- Departures domain, repository contract, server adapter, provider, sealed view state and UI.
- Refresh queue, routes and departures after a taxi departs.
- New unit and widget tests; CI uses `dart analyze --fatal-infos`.

## What has NOT been verified here

- Flutter/Dart were not available in the execution environment used to prepare this revision. The generated files, analyzer, widget tests, and Android deep-link behavior **must be checked locally** before marking them passed.
- This copy has not been committed or pushed, by request.

## Source files and transfer of patterns

| TaxiRank file | Pattern | Why it changed |
| --- | --- | --- |
| `queue_status.dart`, `taxi_action.dart` | Dart 3 domain switches | Safe unknown status and explicit action rules |
| `selected_queue_controller.dart` | Riverpod 3 family | One queue per URL and authoritative payment updates |
| `queue_view_state.dart`, `route_queue_screen.dart` | Sealed UI state | Clear loading, empty, data, 404 and failures |
| `routes.dart`, `taxi_details_provider.dart`, `taxi_details_screen.dart` | go_router typed navigation | Deep links work with IDs instead of screen objects |
| `app_theme.dart` | ThemeExtension | Semantic colours with dark-mode variants |
| `departure.dart` and `departures/*` | Feature layering | Server → repository → provider → sealed state → screen |
| `.github/workflows/ci.yml` | CI gates | Run analyzer in the required mode |

## Boundaries kept and why

- Server versus repository: wire maps and backend rules stay outside the UI.
- Repository versus domain: the app represents money in integer cents, not `double`.
- Domain versus presentation: actions and status labels are testable without widgets.
- Providers versus screen: widgets watch providers, never touch the server directly.
- Router versus screen: URL IDs allow a cold deep link.
- Theme versus feature: widgets use semantic status colours, not hardcoded RGB.

**One boundary I would not remove:** The repository interface. Removing it couples UI work to wire maps and makes error and empty-state tests harder.

## Next steps on the developer's PC

1. Copy the update ZIP contents into the current `Thato_Matamane` branch.
2. Run `flutter pub get`, then `dart run build_runner build --delete-conflicting-outputs`.
3. Run `dart format .` and all four required checks in `APPLY_CHANGES.md`.
4. Run the Android deep-link command in the brief, test all queues and both themes, and inspect failed assertions if any.
5. Record the real passing/failing checks before hand-in. No commit or push was performed here.
