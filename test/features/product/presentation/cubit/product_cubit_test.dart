// TODO(fremartini): uncomment when Mockito supports records, https://github.com/AnalogIO/coffeecard_app/issues/488
//import 'product_cubit_test.mocks.dart';

//@GenerateMocks([GetAllProducts])
void main() {
  /*
  late ProductCubit cubit;
  late MockGetAllProducts getAllProducts;

  setUp(() {
    getAllProducts = MockGetAllProducts();
    cubit = ProductCubit(getAllProducts: getAllProducts);
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
      setUp: () => when(getAllProducts(any))
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
      setUp: () => when(getAllProducts(any))
          .thenAnswer((_) async => const Left(ServerFailure(testError))),
      act: (cubit) => cubit.getProducts(),
      expect: () => [
        const ProductsLoading(),
        const ProductsError(testError),
      ],
    );
  });
  */
}
