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

`.github/workflows/ios-build.yml` runs a simulator build on every push and pull request. To create an IPA for eSign, open **Actions > iOS Build > Run workflow**, leave **Build an unsigned IPA to import into eSign** enabled, and start the workflow. Download `OtInternet-eSign-unsigned-ipa` from the run and import it into eSign for re-signing. This does not publish to the App Store or TestFlight. An unsigned IPA cannot install directly; eSign must sign it with a certificate and provisioning profile that supports the target device.

Configure these secrets for the private IPA build: `BUILD_CERTIFICATE_BASE64`, `P12_PASSWORD`, `PROVISIONING_PROFILE_BASE64`, `KEYCHAIN_PASSWORD`, `APPLE_TEAM_ID`, and `BUNDLE_IDENTIFIER`. App Store Connect API keys are not needed for this private IPA workflow.
