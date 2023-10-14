#! /bin/bash

flutter build ios --flavor development --release --no-codesign --build-name $BUILD_NAME --build-number $BUILD_NUMBER --target lib/main_development.dart
xcodebuild -resolvePackageDependencies -workspace ios/Runner.xcworkspace -scheme development -configuration Release-development
xcodebuild -workspace ios/Runner.xcworkspace -scheme development -configuration Release-development DEVELOPMENT_TEAM=Y5U9T77F2K -sdk 'iphoneos' -destination 'generic/platform=iOS' -archivePath build-output/app.xcarchive PROVISIONING_PROFILE_SPECIFIER="development" clean archive CODE_SIGN_IDENTITY="iPhone Developer"
xcodebuild -exportArchive -archivePath build-output/app.xcarchive -exportPath build-output/ios -exportOptionsPlist ios/exportOptions.dev.plist