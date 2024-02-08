import 'dart:convert';

import 'package:coffeecard/features/session/data/datasources/session_local_data_source.dart';
import 'package:coffeecard/features/session/data/models/session_details_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'session_local_data_source_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage, Logger])
void main() {
  late SessionLocalDataSource sessionLocalDataSource;
  late MockFlutterSecureStorage storage;
  late MockLogger logger;

  setUp(() {
    storage = MockFlutterSecureStorage();
    logger = MockLogger();
    sessionLocalDataSource = SessionLocalDataSource(
      storage: storage,
      logger: logger,
    );
  });

  group('saveSessionDetails', () {
    test('should write to local storage', () async {
      // arrange
      final sessionDetails = SessionDetailsModel(
        sessionTimeout: none(),
        lastLogin: none(),
      );

      // act
      await sessionLocalDataSource.saveSessionDetails(sessionDetails);

      // assert
      verify(
        storage.write(
          key: anyNamed('key'),
          value: json.encode(sessionDetails.toJson()),
        ),
      );
    });
  });
  group('getSessionDetails', () {
    test('should return none if nothing is stored', () async {
      // arrange
      when(storage.read(key: anyNamed('key'))).thenAnswer((_) async => null);

      // act
      final actual = await sessionLocalDataSource.getSessionDetails();

      // assert
      expect(actual, none());
    });

    test('should return session if stored', () async {
      // arrange
      final sessionDetails = SessionDetailsModel(
        sessionTimeout: none(),
        lastLogin: none(),
      );

      when(storage.read(key: anyNamed('key')))
          .thenAnswer((_) async => json.encode(sessionDetails));

      // act
      final actual = await sessionLocalDataSource.getSessionDetails();

      // assert
      expect(actual, some(sessionDetails));
    });
  });
}
