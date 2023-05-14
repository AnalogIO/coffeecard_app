import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/cubits/products/products_cubit.dart';
import 'package:coffeecard/data/repositories/v1/product_repository.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'products_cubit_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  const dummyProducts = [
    Product(
      id: 1,
      name: 'test (bundle of 10)',
      amount: 10,
      price: 1,
      description: 'test',
    ),
    Product(
      id: 2,
      name: 'test (single)',
      amount: 1,
      price: 1,
      description: 'test',
    ),
  ];
  group('products cubit tests', () {
    late ProductsCubit productsCubit;
    final repo = MockProductRepository();

    setUp(() {
      productsCubit = ProductsCubit(repo);
    });

    blocTest<ProductsCubit, ProductsState>(
      'should emit loading and loaded when repo.getProducts succeeds',
      build: () {
        when(repo.getProducts())
            .thenAnswer((_) async => const Right(dummyProducts));
        return productsCubit;
      },
      act: (cubit) => cubit.getProducts(),
      expect: () => [
        const ProductsLoading(),
        ProductsLoaded([dummyProducts.first], [dummyProducts[1]]),
      ],
    );

    blocTest<ProductsCubit, ProductsState>(
      'should emit loading and error when repo.getProducts fails',
      build: () {
        when(repo.getProducts())
            .thenAnswer((_) async => const Left(ServerFailure('some error')));
        return productsCubit;
      },
      act: (cubit) => cubit.getProducts(),
      expect: () => [
        const ProductsLoading(),
        const ProductsError('some error'),
      ],
    );

    tearDown(() {
      productsCubit.close();
    });
  });
}
