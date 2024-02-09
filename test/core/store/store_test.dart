import 'dart:convert';

import 'package:coffeecard/core/store/store.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FlutterSecureStorage>(),
  MockSpec<HiveInterface>(),
  MockSpec<Box<String>>(),
])
void main() {
  final secureStorage = MockFlutterSecureStorage();
  final hive = MockHiveInterface();
  final store = Store(secureStorage: secureStorage, hive: hive);

  group('openCrate', () {
    test(
      'GIVEN an initialized Store '
      'WHEN openCrate is called '
      'THEN '
      '1) HiveInterface.openBox is called with the given boxName '
      '2) The Crate is returned in a Task',
      () async {
        // arrange
        const crateName = 'a';

        // act
        final result = await store.openCrate<String>(crateName).run();

        // assert
        verify(hive.openBox<String>(crateName)).called(1);
        verifyNoMoreInteractions(hive);
        verifyZeroInteractions(secureStorage);
        expect(result, isA<Crate<String>>());
      },
    );
  });

  group('openEncryptedCrate', () {
    test(
      'GIVEN '
      '1) an initialized Store '
      '2) no encryption key stored in FlutterSecureStorage '
      'WHEN openEncryptedCrate is called '
      'THEN '
      '1) FlutterSecureStorage.read is called '
      '2) Hive.generateSecureKey is called '
      '3) FlutterSecureStorage.write is called '
      '4) Hive.openBox is called with the given crate name and any cipher '
      '5) The Crate is returned in a Task',
      () async {
        // arrange
        const crateName = 'a';
        final encryptionKey = List<int>.generate(32, (index) => index);
        final encodedEncryptionKey = base64.encode(encryptionKey);

        when(secureStorage.read(key: anyNamed('key')))
            .thenAnswer((_) async => null);

        when(hive.generateSecureKey()).thenReturn(encryptionKey);

        // act
        final result = await store.openEncryptedCrate<String>(crateName).run();

        // assert
        verify(secureStorage.read(key: anyNamed('key'))).called(1);
        verify(hive.generateSecureKey()).called(1);
        verify(
          secureStorage.write(
            key: anyNamed('key'),
            value: encodedEncryptionKey,
          ),
        ).called(1);
        verify(
          hive.openBox<String>(
            crateName,
            encryptionCipher: anyNamed('encryptionCipher'),
          ),
        ).called(1);

        verifyNoMoreInteractions(hive);
        verifyNoMoreInteractions(secureStorage);
        expect(result, isA<Crate<String>>());
      },
    );

    test(
      'GIVEN '
      '1) an initialized Store '
      '2) an encryption key stored in FlutterSecureStorage '
      'WHEN openEncryptedCrate is called '
      'THEN '
      '1) FlutterSecureStorage.read is called '
      '2) FlutterSecureStorage.write is called '
      '3) Hive.openBox is called with the given crate name and any cipher '
      '4) The Crate is returned in a Task',
      () async {
        // arrange
        const crateName = 'a';
        final encryptionKey = List<int>.generate(32, (index) => index);
        final encodedEncryptionKey = base64.encode(encryptionKey);

        when(secureStorage.read(key: anyNamed('key')))
            .thenAnswer((_) async => encodedEncryptionKey);

        // act
        final result = await store.openEncryptedCrate<String>(crateName).run();

        // assert
        verify(secureStorage.read(key: anyNamed('key'))).called(1);
        verify(
          secureStorage.write(
            key: anyNamed('key'),
            value: encodedEncryptionKey,
          ),
        ).called(1);
        verify(
          hive.openBox<String>(
            crateName,
            encryptionCipher: anyNamed('encryptionCipher'),
          ),
        ).called(1);

        verifyNoMoreInteractions(hive);
        verifyNoMoreInteractions(secureStorage);
        expect(result, isA<Crate<String>>());
      },
    );
  });
}
