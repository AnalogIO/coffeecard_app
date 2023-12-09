# GitHub Actions Workflow Secrets

#### ANDROID_KEYSTORE_PASSWORD
Keystore password

#### ANDROID_KEY_ALIAS
Alias for signing key in keystore

#### ANDROID_KEY_PASSWORD
Key password

#### APPLE_IOS_PROVISIONING_PROFILE_DEVELOPMENT
iOS Provisioning profile for development releases in base64 encoded format. The provisioning profile must be updated each time a new device is added to the profile in App Store Connect.

#### APPLE_IOS_PROVISIONING_PROFILE_PROD
iOS Provisioning profile for production releases in base64 encoded format

#### APPLE_IOS_SIGNING_CERTIFICATE_DEVELOPMENT
iOS certificate in base64 encoded format used to sign iOS app for development releases

#### APPLE_IOS_SIGNING_CERTIFICATE_DEVELOPMENT_PASSWORD
Certificate password

#### APPLE_IOS_SIGNING_CERT_PROD
iOS certificate in base64 encoded format used to sign iOS app for production releases

#### APPLE_IOS_SIGNING_CERT_PW
Certificate password

#### APPLE_KEYCHAIN_PW
Apple Keychain password

#### APP_STORE_CONNECT_PASSWORD
Apple App Store connect password

#### APP_STORE_CONNECT_USERNAME
Apple App Store connect username for GitHub Actions service user

#### FIREBASE_ANDROID_APP_ID
Firebase Android App identifier

#### FIREBASE_ANDROID_SERVICES_JSON
Google Services file for Android in JSON format

#### FIREBASE_IOS_APP_ID
Firebase iOS App identifier

#### FIREBASE_IOS_SERVICES_JSON
Google Services file for iOS in JSON format

#### FIREBASE_SERVICE_ACCOUNT_JSON
This is the service account key from Firebase, which is required for Firebase App Distribution. It's a JSON object that contains your service account credentials. It's used in the GitHub Actions workflows for distributing the app to Firebase.

#### PLAYSTORE_SERVICE_ACCOUNT_JSON
Google Play store service account used to authenticate to Play store in JSON format