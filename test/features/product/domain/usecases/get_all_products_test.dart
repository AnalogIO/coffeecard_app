// TODO(fremartini): uncomment when Mockito supports records, https://github.com/AnalogIO/coffeecard_app/issues/488
//import 'get_all_products_test.mocks.dart';

//@GenerateMocks([ProductRemoteDataSource])
void main() {
  /*
  late GetAllProducts usecase;
  late MockProductRemoteDataSource remoteDataSource;

  setUp(() {
    remoteDataSource = MockProductRemoteDataSource();
    usecase = GetAllProducts(remoteDataSource: remoteDataSource);
  });

  const testError = 'some error';

  test('should return [Left] if data source fails', () async {
    // arrange
    when(remoteDataSource.getProducts())
        .thenAnswer((_) async => const Left(ServerFailure(testError)));

    // act
    final actual = await usecase(NoParams());

    // assert
    expect(actual, const Left(ServerFailure(testError)));
  });

  test(
    'should return [Right<Iterable<Product>, Iterable<Product>>] if data source succeeds',
    () async {
      // arrange
      const products = [
        ProductModel(
          id: 1,
          name: 'test (bundle of 10)',
          amount: 10,
          price: 1,
          description: 'test',
        ),
        ProductModel(
          id: 2,
          name: 'test (single)',
          amount: 1,
          price: 1,
          description: 'test',
        ),
      ];

      when(remoteDataSource.getProducts())
          .thenAnswer((_) async => const Right(products));

      // act
      final actual = await usecase(NoParams());

      // assert
      actual.fold(
        (_) => throw Exception(),
        (actual) {
          expect(actual.$1, [products.first]);
          expect(actual.$2, [products[1]]);
        },
      );
    },
  );
  */
}