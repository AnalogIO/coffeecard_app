import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:coffeecard/features/product/domain/usecases/get_all_products.dart';
import 'package:coffeecard/features/product/presentation/cubit/product_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_cubit_test.mocks.dart';

@GenerateMocks([GetAllProducts])
void main() {
  late ProductCubit cubit;
  late MockGetAllProducts getAllProducts;

  setUp(() {
    getAllProducts = MockGetAllProducts();
    cubit = ProductCubit(getAllProducts: getAllProducts);

    provideDummy<Either<Failure, (List<Product>, List<Product>)>>(
      const Left(ConnectionFailure()),
    );
  });

  const tickets = [
    Product(
      id: 1,
      name: 'test (bundle of 10)',
      amount: 10,
      price: 1,
      description: 'test',
      isPerk: false,
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
    ),
  ];

  const testError = 'some error';

  group('getProducts', () {
    blocTest(
      'should emit [Loading, Loaded] use case succeeds',
      build: () => cubit,
      setUp: () => when(getAllProducts(any))
          .thenAnswer((_) async => const Right((tickets, singleDrinks, perks))),
      act: (cubit) => cubit.getProducts(),
      expect: () => [
        const ProductsLoading(),
        const ProductsLoaded(
          clipCards: tickets,
          singleDrinks: singleDrinks,
          perks: perks,
        ),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when use case fails',
      build: () => cubit,
      setUp: () => when(getAllProducts(any))
          .thenAnswer((_) async => const Left(ServerFailure(testError))),
      act: (cubit) => cubit.getProducts(),
      expect: () => [
        const ProductsLoading(),
        const ProductsError(testError),
      ],
    );
  });
}
