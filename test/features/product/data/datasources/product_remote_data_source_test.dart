import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/product/data/datasources/product_remote_data_source.dart';
import 'package:coffeecard/features/product/data/models/product_model.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_remote_data_source_test.mocks.dart';

@GenerateMocks([CoffeecardApiV2, NetworkRequestExecutor])
void main() {
  late ProductRemoteDataSource remoteDataSource;
  late MockCoffeecardApiV2 api;
  late MockNetworkRequestExecutor executor;

  setUp(() {
    executor = MockNetworkRequestExecutor();
    api = MockCoffeecardApiV2();
    remoteDataSource = ProductRemoteDataSource(api: api, executor: executor);

    provideDummy<Either<NetworkFailure, List<ProductResponse>>>(
      const Left(ConnectionFailure()),
    );
  });

  group('getProducts', () {
    test('should call executor', () async {
      // arrange
      when(executor.execute<List<ProductResponse>>(any)).thenAnswer(
        (_) async => const Right([
          ProductResponse(
            id: 0,
            price: 0,
            numberOfTickets: 0,
            name: 'name',
            description: 'description',
            isPerk: false,
          ),
        ]),
      );

      // act
      final actual = await remoteDataSource.getProducts();

      // assert
      actual.fold(
        (_) => throw Exception(),
        (actual) {
          expect(
            actual,
            [
              const ProductModel(
                price: 0,
                amount: 0,
                name: 'name',
                id: 0,
                description: 'description',
                isPerk: false,
              ),
            ],
          );
        },
      );
    });
  });
}
