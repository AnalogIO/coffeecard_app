import 'package:coffeecard/core/store/store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'store_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Box<String>>()])
void main() {
  late Box<String> box;
  late Crate<String> crate;

  setUp(() {
    box = MockBox();
    crate = Crate(box);
  });

  tearDown(() async => crate.clear());
  tearDownAll(() async => box.deleteFromDisk());

  test(
    'GIVEN a Crate '
    'WHEN put is called '
    'THEN Box.put is called with the given key and value',
    () async {
      // arrange
      const key = 'a';
      const value = 'b';

      // act
      final _ = await crate.put(key, value).run();

      // assert
      verify(box.put(key, value)).called(1);
    },
  );

  test(
    'GIVEN a Crate '
    'WHEN get is called '
    'THEN Box.get is called with the given key and Some(value) is returned',
    () async {
      // arrange
      const key = 'a';
      when(box.get(key)).thenReturn('b');

      // act
      final actual = await crate.get(key).run();

      // assert
      verify(box.get(key)).called(1);
      expect(actual, isA<Some<String>>());
    },
  );

  test(
    'GIVEN a Crate '
    'WHEN clear is called '
    'THEN Box.clear is called',
    () async {
      // act
      final _ = await crate.clear().run();

      // assert
      verify(box.clear()).called(1);
    },
  );
}
