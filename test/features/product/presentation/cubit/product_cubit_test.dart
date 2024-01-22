import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/product/menu_item_model.dart';
import 'package:coffeecard/features/product/presentation/cubit/product_cubit.dart';
import 'package:coffeecard/features/product/product_model.dart';
import 'package:coffeecard/features/product/product_repository.dart';
import 'package:coffeecard/features/product/purchasable_products.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProductRepository>()])
void main() {
  late ProductCubit cubit;
  late MockProductRepository productRepository;

  setUp(() {
    productRepository = MockProductRepository();
    cubit = ProductCubit(productRepository: productRepository);

    provideDummy<TaskEither<Failure, Iterable<Product>>>(
      TaskEither.left(const ConnectionFailure()),
    );
  });

  const testMenuItems = [
    MenuItem(id: 1, name: 'Cappuccino'),
    MenuItem(id: 2, name: 'Espresso'),
  ];

  const tickets = [
    Product(
      id: 1,
      name: 'test (bundle of 10)',
      amount: 10,
      price: 1,
      description: 'test',
      isPerk: false,
      eligibleMenuItems: testMenuItems,
    ),
  ];
  const singleDrinks = [
    Product(
      id: 2,
      name: 'test (single)',
      amount: 1,
      price: 1,
      description: 'test',
      isPerk: false,
      eligibleMenuItems: testMenuItems,
    ),
  ];
  const perks = [
    Product(
      id: 999,
      name: 'Gratis filter',
      amount: 1,
      price: 0,
      description: 'deription',
      isPerk: true,
      eligibleMenuItems: testMenuItems,
    ),
  ];

  const groupedProducts = (
    clipCards: tickets,
    singleDrinks: singleDrinks,
    perks: perks,
  );

  final allProducts = groupedProducts.all;

  const testFailure = Left<Failure, Iterable<Product>>(
    ServerFailure('some error', 500),
  );

  group('getProducts', () {
    blocTest(
      'should emit [Loaded] use case succeeds',
      build: () => cubit,
      setUp: () => when(productRepository.getProducts())
          .thenAnswer((_) => TaskEither.fromEither(Right(allProducts))),
      act: (cubit) => cubit.getProducts(),
      expect: () => [isA<ProductsLoaded>()],
    );

    blocTest(
      'should emit [Error] when use case fails',
      build: () => cubit,
      setUp: () => when(productRepository.getProducts())
          .thenAnswer((_) => TaskEither.fromEither(testFailure)),
      act: (cubit) => cubit.getProducts(),
      expect: () => [isA<ProductsError>()],
    );
  });
}
