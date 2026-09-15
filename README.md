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

`.github/workflows/ios-build.yml` runs a simulator build on every push and pull request. To request a private device-testing IPA, open **Actions > iOS Build > Run workflow**, enable **Build a private signed IPA for device testing**, and start the workflow. This does not publish to the App Store or TestFlight. A device IPA still requires an Apple Developer team, a valid signing certificate, and a matching development or ad-hoc provisioning profile. An unsigned archive or IPA cannot be installed on a physical iPhone.

Configure these secrets for the private IPA build: `BUILD_CERTIFICATE_BASE64`, `P12_PASSWORD`, `PROVISIONING_PROFILE_BASE64`, `KEYCHAIN_PASSWORD`, `APPLE_TEAM_ID`, and `BUNDLE_IDENTIFIER`. App Store Connect API keys are not needed for this private IPA workflow.
