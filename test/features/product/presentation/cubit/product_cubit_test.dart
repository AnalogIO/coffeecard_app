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
    ),
  ];
  const singleDrinks = [
    Product(
      id: 2,
      name: 'test (single)',
      amount: 1,
      price: 1,
      description: 'test',
    ),
  ];

  const testError = 'some error';

  group('getProducts', () {
    blocTest(
      'should emit [Loading, Loaded] use case succeeds',
      build: () => cubit,
      setUp: () => when(getAllProducts())
          .thenAnswer((_) async => const Right((tickets, singleDrinks))),
      act: (cubit) => cubit.getProducts(),
      expect: () => [
        const ProductsLoading(),
        const ProductsLoaded(tickets, singleDrinks),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when use case fails',
      build: () => cubit,
      setUp: () => when(getAllProducts())
          .thenAnswer((_) async => const Left(ServerFailure(testError))),
      act: (cubit) => cubit.getProducts(),
      expect: () => [
        const ProductsLoading(),
        const ProductsError(testError),
      ],
    );
  });
}
