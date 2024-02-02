import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';

extension FlutterSecureStorageFP on FlutterSecureStorage {
  /// [TaskOption] wrapper around [read].
  TaskOption<String> readAsTaskOption(String key) {
    return TaskOption(
      () async => Option.fromNullable(await read(key: key)),
    );
  }

  /// [Task] wrapper around [write].
  Task<Unit> writeAsTask({required String key, required String value}) {
    return Task(() => write(key: key, value: value)).map((_) => unit);
  }
}

extension HiveFP on HiveInterface {
  /// [Task] wrapper around [openBox].
  Task<Box<E>> openBoxAsTask<E>(String name, {HiveCipher? encryptionCipher}) =>
      Task(() => openBox<E>(name, encryptionCipher: encryptionCipher));

  /// Open an encrypted box in a [Task].
  ///
  /// The encryption key is stored in FlutterSecureStorage as a base64 encoded
  /// string. If the key does not exist, a new key is generated and stored.
  Task<Box<E>> openEncryptedBox<E>(String boxName) {
    const secureStorage = FlutterSecureStorage();

    /// The location of the Hive encryption key in FlutterSecureStorage.
    const secureStorageHiveEncryptionKey = 'hiveEncryptionKeyString';

    Task<Unit> saveHiveEncryptionKey(List<int> encryptionKey) {
      return secureStorage.writeAsTask(
        key: secureStorageHiveEncryptionKey,
        value: base64.encode(encryptionKey),
      );
    }

    return secureStorage
        .readAsTaskOption(secureStorageHiveEncryptionKey)
        .map<List<int>>(base64.decode)
        .getOrElse(Hive.generateSecureKey)
        .chainFirst(saveHiveEncryptionKey)
        .map(HiveAesCipher.new)
        .flatMap(
          (cipher) => Hive.openBoxAsTask<E>(
            secureStorageHiveEncryptionKey,
            encryptionCipher: cipher,
          ),
        );
  }
}
