# Apply the TaxiRank source update (no commit or push)

This ZIP contains only changed or new source, tests and markdown files. It does **not** include `.git`, `lib/core/fakes/`, or `test/support/harness.dart`. It leaves the original project in place and changes only matching paths when extracted.

## Windows PowerShell

1. Verify you're in the correct branch:

   ```powershell
   cd C:\Users\LCBitcube\Downloads\taxirank-starter
   git branch --show-current
   git status --short
   ```

   The branch must be `Thato_Matamane`. For safety, copy the entire project folder somewhere else before overwriting files.

2. Unzip `taxirank-updated-files.zip` **into** `C:\Users\LCBitcube\Downloads\taxirank-starter` (not into a new nested subfolder). For example, if the ZIP is in Downloads:

   ```powershell
   Expand-Archive -Path "C:\Users\LCBitcube\Downloads\taxirank-updated-files.zip" -DestinationPath "C:\Users\LCBitcube\Downloads\taxirank-starter" -Force
   ```

3. Regenerate Riverpod and typed-route files. The supplied ZIP intentionally excludes generated `.g.dart` files:

   ```powershell
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   dart format .
   dart analyze --fatal-infos
   flutter test
   flutter run
   ```

4. Test the cold deep link (Android emulator/device):

   ```powershell
   adb shell am force-stop za.co.taxirank.taxirank
   adb shell am start -a android.intent.action.VIEW -d "taxirank://app/queues/soweto/taxis/tx-102"
   ```

5. Check `git diff` to inspect changes. **Do not run `git add`, `git commit`, or `git push` unless you decide to do that later.**

## Known caveat

There was no Flutter/Dart SDK in the environment that produced these files, so code generation, analysis, tests and device behavior cannot be guaranteed. Use the commands above and address any errors before relying on the build.
