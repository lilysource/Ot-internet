# Ot Internet

Ot Internet is a native SwiftUI iOS app for useful and entertaining offline moments. The core experience requires no account, API, or network connection.

## Included

- Local-first Home dashboard and offline status
- Playable 2048 with swipe controls, undo, restart, score, and UserDefaults best score
- Offline Games catalog with local game launch surfaces
- SwiftData Notes with create, edit, search, favorite, pin, and delete
- Saved Places for locally stored map data, with no claim that online MapKit tiles are available offline
- Local Files import surface, offline tools, and settings
- English-first copy with a localization-ready structure

## Run in Xcode

Open `OtInternet.xcodeproj` on macOS with Xcode 15 or newer. Select an iPhone Simulator and run. The package target contains the pure game logic and tests.

## CI and signing

`.github/workflows/ios-build.yml` creates an unsigned device archive and IPA package on every push and pull request. It does not require an iOS Simulator runtime. Open **Actions > Ot Internet iOS Build**, select a run, and download the `OtInternet-iOS-IPA` artifact. Import `OtInternet-unsigned.ipa` into eSign for re-signing. This does not publish to the App Store or TestFlight. An unsigned IPA cannot install directly; eSign must sign it with a certificate and provisioning profile that supports the target device.

No Apple signing secrets are required for this unsigned eSign artifact. The workflow also uploads `OtInternet-XCArchive` for debugging and reuse. App Store Connect API keys are not needed.
