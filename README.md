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

`.github/workflows/ios-build.yml` runs a simulator build on every push. A device IPA requires an Apple Developer team, a valid distribution certificate, and a matching provisioning profile. The workflow includes an optional signed archive path driven by GitHub Secrets; no signing material belongs in this repository. An unsigned archive or IPA cannot be installed on a physical iPhone.

Configure these secrets for signed builds: `BUILD_CERTIFICATE_BASE64`, `P12_PASSWORD`, `PROVISIONING_PROFILE_BASE64`, `KEYCHAIN_PASSWORD`, `APPLE_TEAM_ID`, and `BUNDLE_IDENTIFIER`. TestFlight publishing additionally requires App Store Connect API key secrets.
