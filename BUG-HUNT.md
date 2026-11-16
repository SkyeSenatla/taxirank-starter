# Week 10 Bug Hunt

## Findings
- Taxi detail screen accessed the data layer directly.
- Taxi detail provider was duplicated.

## Corrections
- Moved taxi lookup into a dedicated Riverpod provider.
- Removed duplicate provider declaration from the screen.
- Updated the screen to consume the dedicated provider.

## Verification
- Latest recorded Flutter test run: 5 passed, 0 failed.
- Static analysis still has outstanding findings.
