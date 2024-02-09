import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart' as hive hide Hive;

part 'crate.dart';

/// Persistent storage for key-value pairs.
///
/// Powered by Hive and FlutterSecureStorage to provide both encrypted and
/// unencrypted storage.
class Store {
  const Store({
    required FlutterSecureStorage secureStorage,
    required hive.HiveInterface hive,
  })  : _secureStorage = secureStorage,
        _hive = hive;

  final FlutterSecureStorage _secureStorage;
  final hive.HiveInterface _hive;

  /// Opens a [Crate] with the given [name].
  Task<Crate<E>> openCrate<E>(String name) => _openBox<E>(name);

  /// Opens an encrypted [Crate] with the given [name].
  ///
  /// If an encryption key is not found, a new one will be generated and saved.
  Task<Crate<E>> openEncryptedCrate<E>(String name) {
    return _readEncryptionKey()
        .map<List<int>>(base64.decode)
        .getOrElse(_hive.generateSecureKey)
        .chainFirst(_saveEncryptionKey)
        .map(hive.HiveAesCipher.new)
        .flatMap((cipher) => _openBox<E>(name, cipher: cipher));
  }

  /// [Task] wrapper around [HiveInterface.openBox].
  Task<Crate<E>> _openBox<E>(String boxName, {hive.HiveCipher? cipher}) {
    return Task(
      () async {
        return Crate(await _hive.openBox<E>(boxName, encryptionCipher: cipher));
      },
    );
  }

  /// [TaskOption] wrapper around [FlutterSecureStorage.read].
  TaskOption<String> _readEncryptionKey() {
    return TaskOption(
      () async => Option.fromNullable(
        await _secureStorage.read(key: _encryptionKeyLocation),
      ),
    );
  }

  /// [Task] wrapper around [FlutterSecureStorage.write].
  Task<Unit> _saveEncryptionKey(List<int> encryptionKey) {
    return Task(() async {
      await _secureStorage.write(
        key: _encryptionKeyLocation,
        value: base64.encode(encryptionKey),
      );
      return unit;
    });
  }

  /// The location of the Hive encryption key in FlutterSecureStorage.
  static const _encryptionKeyLocation = 'hiveEncryptionKeyString';
}
