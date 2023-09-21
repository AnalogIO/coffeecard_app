import 'dart:convert' show base64Encode, utf8;

import 'package:crypto/crypto.dart' show sha256;

String encodePasscode(String passcode) {
  final bytes = utf8.encode(passcode);
  final passcodeHash = sha256.convert(bytes);
  return base64Encode(passcodeHash.bytes);
}
