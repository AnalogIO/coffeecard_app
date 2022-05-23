# create variables
CERTIFICATE_PATH=$RUNNER_TEMP/build_certificate.p12
PP_PATH=$RUNNER_TEMP/build_pp.mobileprovision
KEYCHAIN_PATH=$RUNNER_TEMP/app-signing.keychain-db

# import certificate and provisioning profile from secrets
echo -n "$APPLE_IOS_SIGNING_CERT" | base64 --decode --output $CERTIFICATE_PATH
echo -n "$APPLE_IOS_PROVISIONING_PROFILE" | base64 --decode --output $PP_PATH

# create temporary keychain
security create-keychain -p "$APPLE_KEYCHAIN_PW" $KEYCHAIN_PATH
security set-keychain-settings -lut 21600 $KEYCHAIN_PATH
security unlock-keychain -p "$APPLE_KEYCHAIN_PW" $KEYCHAIN_PATH

# import certificate to keychain
security import $CERTIFICATE_PATH -P "$APPLE_IOS_SIGNING_CERT_PW" -A -t cert -f pkcs12 -k $KEYCHAIN_PATH
security list-keychain -d user -s $KEYCHAIN_PATH

# apply provisioning profile
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp $PP_PATH ~/Library/MobileDevice/Provisioning\ Profiles