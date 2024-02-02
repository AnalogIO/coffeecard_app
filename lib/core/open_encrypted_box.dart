import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// The location of the Hive encryption key in FlutterSecureStorage.
const _secureStorageHiveEncryptionKey = 'hiveEncryptionKeyString';

/// Get an encrypted Hive box.
///
/// The encryption key is stored in FlutterSecureStorage as a base64 encoded
/// string. If the key does not exist, a new key is generated and stored.
Task<Box<T>> getEncryptedBox<T>(String boxKey) {
  return Task(() async {
    const secureStorage = FlutterSecureStorage();

    // Get the Hive encryption key from FlutterSecureStorage, or generate a
    // new key if it does not exist.
    final maybeHiveEncryptionKeyString = Option.fromNullable(
      await secureStorage.read(key: _secureStorageHiveEncryptionKey),
    );

    final hiveEncryptionKey = maybeHiveEncryptionKeyString
        .map(base64Url.decode)
        .map(HiveAesCipher.new)
        .getOrElse(() => HiveAesCipher(Hive.generateSecureKey()));

    return Hive.openBox<T>(boxKey, encryptionCipher: hiveEncryptionKey);
  });
}
