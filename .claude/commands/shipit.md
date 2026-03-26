Build release builds for Android and iOS, then open the output folders and Transporter for app store submission.

Steps:
1. Build Android App Bundle (AAB) for Play Store release
2. Build iOS archive for App Store release
3. Open the Android build output folder in Finder
4. Open the iOS build output folder in Finder
5. Open Transporter app for uploading to App Store

Commands to run:
```bash
# Build Android App Bundle
flutter build appbundle --release

# Build iOS (creates archive that needs to be exported in Xcode)
flutter build ipa --release

# Open build output folders
open build/app/outputs/bundle/release
open build/ios/archive

# Open Transporter
open -a Transporter
```

Note: For iOS, you may need to use Xcode to "Distribute App" from the archive before uploading to App Store Connect. The flutter build ipa command creates the archive.
