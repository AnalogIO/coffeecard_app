#! /bin/bash

BUILD_NAME=$1
BUILD_NUMBER=$2

flutter build ios --flavor production --release --no-codesign --build-name $BUILD_NAME --build-number $BUILD_NUMBER --target lib/main_production.dart
xcodebuild -resolvePackageDependencies -workspace ios/Runner.xcworkspace -scheme production -configuration Release-production
xcodebuild -workspace ios/Runner.xcworkspace -scheme production -configuration Release-production DEVELOPMENT_TEAM=Y5U9T77F2K -sdk 'iphoneos' -destination 'generic/platform=iOS' -archivePath build-output/app.xcarchive PROVISIONING_PROFILE_SPECIFIER="githubactions-prod" clean archive CODE_SIGN_IDENTITY="Apple Distribution"
xcodebuild -exportArchive -archivePath build-output/app.xcarchive -exportPath build-output/ios -exportOptionsPlist ios/exportOptions.prod.plist
