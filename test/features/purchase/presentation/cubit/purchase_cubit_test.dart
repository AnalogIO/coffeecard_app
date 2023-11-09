import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/firebase_analytics_event_logging.dart';
import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:coffeecard/features/purchase/domain/usecases/init_purchase.dart';
import 'package:coffeecard/features/purchase/domain/usecases/verify_purchase_status.dart';
import 'package:coffeecard/features/purchase/presentation/cubit/purchase_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'purchase_cubit_test.mocks.dart';

@GenerateMocks(
  [InitPurchase, VerifyPurchaseStatus, FirebaseAnalyticsEventLogging],
)
void main() {
  late MockInitPurchase initPurchase;
  late MockVerifyPurchaseStatus verifyPurchaseStatus;
  late MockFirebaseAnalyticsEventLogging firebaseAnalyticsEventLogging;
  late PurchaseCubit cubit;

  const testProduct = Product(
    price: 0,
    amount: 0,
    name: 'name',
    id: 0,
    description: 'description',
    isPerk: false,
  );

  setUp(() {
    initPurchase = MockInitPurchase();
    verifyPurchaseStatus = MockVerifyPurchaseStatus();
    firebaseAnalyticsEventLogging = MockFirebaseAnalyticsEventLogging();
    cubit = PurchaseCubit(
      product: testProduct,
      initPurchase: initPurchase,
      verifyPurchaseStatus: verifyPurchaseStatus,
      firebaseAnalyticsEventLogging: firebaseAnalyticsEventLogging,
    );

    provideDummy<Either<Failure, Payment>>(
      const Left(ConnectionFailure()),
    );
    provideDummy<Either<Failure, PaymentStatus>>(
      const Left(ConnectionFailure()),
    );
  });

  const testError = 'some error';

  Payment createTestPayment(PaymentStatus status) => Payment(
        status: status,
        deeplink: 'deeplink',
        id: 0,
        price: 0,
        productId: 0,
        productName: 'productName',
        purchaseTime: DateTime.parse('2023-05-19'),
      );

  group('pay', () {
    blocTest<PurchaseCubit, PurchaseState>(
      'should not emit new state if state is not [Initial]',
      build: () => cubit,
      setUp: () {
        when(firebaseAnalyticsEventLogging.beginCheckoutEvent(any))
            .thenReturn(null);
      },
      seed: () => const PurchaseError(testError),
      act: (_) => cubit.pay(),
      expect: () => [],
    );

    blocTest(
      'should emit [Started, Error] if use case fails',
      build: () => cubit,
      setUp: () {
        when(firebaseAnalyticsEventLogging.beginCheckoutEvent(any))
            .thenReturn(null);
        when(initPurchase(any))
            .thenAnswer((_) async => const Left(ServerFailure(testError, 500)));
      },
      act: (_) => cubit.pay(),
      expect: () => [
        const PurchaseStarted(),
        const PurchaseError(testError),
      ],
    );

    blocTest(
      'should emit [Started, Completed] if payment is completed',
      build: () => cubit,
      setUp: () {
        when(firebaseAnalyticsEventLogging.beginCheckoutEvent(any))
            .thenReturn(null);
        when(initPurchase(any)).thenAnswer(
          (_) async => Right(createTestPayment(PaymentStatus.completed)),
        );
      },
      act: (_) => cubit.pay(),
      expect: () => [
        const PurchaseStarted(),
        PurchaseCompleted(createTestPayment(PaymentStatus.completed)),
      ],
    );

    blocTest(
      'should emit [Started, Processing] if payment is awaiting',
      build: () => cubit,
      setUp: () {
        when(firebaseAnalyticsEventLogging.beginCheckoutEvent(any))
            .thenReturn(null);
        when(initPurchase(any)).thenAnswer(
          (_) async => Right(createTestPayment(PaymentStatus.awaitingPayment)),
        );
      },
      act: (_) => cubit.pay(),
      expect: () => [
        const PurchaseStarted(),
        PurchaseProcessing(createTestPayment(PaymentStatus.awaitingPayment)),
      ],
    );

    blocTest(
      'should emit [Started, Rejected] if payment is rejected',
      build: () => cubit,
      setUp: () {
        when(firebaseAnalyticsEventLogging.beginCheckoutEvent(any))
            .thenReturn(null);
        when(initPurchase(any)).thenAnswer(
          (_) async => Right(createTestPayment(PaymentStatus.rejectedPayment)),
        );
      },
      act: (_) => cubit.pay(),
      expect: () => [
        const PurchaseStarted(),
        PurchasePaymentRejected(
          createTestPayment(PaymentStatus.rejectedPayment),
        ),
      ],
    );
  });

  group('verifyPurchase', () {
    blocTest<PurchaseCubit, PurchaseState>(
      'should not emit new state if state is not [Processing]',
      build: () => cubit,
      seed: () => const PurchaseError(testError),
      act: (_) => cubit.verifyPurchase(),
      expect: () => [],
    );

    blocTest<PurchaseCubit, PurchaseState>(
      'should emit [Verifying] and check purchase status',
      build: () => cubit,
      seed: () => PurchaseProcessing(
        createTestPayment(PaymentStatus.awaitingPayment),
      ),
      setUp: () {
        when(verifyPurchaseStatus(any))
            .thenAnswer((_) async => const Left(ServerFailure(testError, 500)));
      },
      act: (_) => cubit.verifyPurchase(),
      expect: () => [
        PurchaseVerifying(createTestPayment(PaymentStatus.awaitingPayment)),
        const PurchaseError(testError),
      ],
    );
  });

  group('validatePurchaseStatusAtInterval', () {
    blocTest(
      'should emit [Timeout] if iterations exceed maxIterations',
      build: () => cubit,
      setUp: () {
        when(verifyPurchaseStatus(any)).thenAnswer(
          (_) async => const Right(PaymentStatus.reserved),
        );
      },
      act: (_) async => cubit.validatePurchaseStatusAtInterval(
        createTestPayment(PaymentStatus.completed),
        maxIterations: 1,
      ),
      expect: () =>
          [PurchaseTimeout(createTestPayment(PaymentStatus.completed))],
    );
  });

  group('checkPurchaseStatus', () {
    blocTest(
      'should emit [Error] when use case fails',
      build: () => cubit,
      setUp: () {
        when(verifyPurchaseStatus(any)).thenAnswer(
          (_) async => const Left(ServerFailure(testError, 500)),
        );
      },
      act: (_) async => cubit.checkPurchaseStatus(
        createTestPayment(PaymentStatus.completed),
        () async {},
      ),
      expect: () => [const PurchaseError(testError)],
    );

    blocTest(
      'should emit [Completed] when status is Completed',
      build: () => cubit,
      setUp: () {
        when(verifyPurchaseStatus(any)).thenAnswer(
          (_) async => const Right(PaymentStatus.completed),
        );
      },
      act: (_) async => cubit.checkPurchaseStatus(
        createTestPayment(PaymentStatus.completed),
        () async {},
      ),
      expect: () =>
          [PurchaseCompleted(createTestPayment(PaymentStatus.completed))],
    );

    blocTest(
      'should emit [Rejected] when status is Error',
      build: () => cubit,
      setUp: () {
        when(verifyPurchaseStatus(any)).thenAnswer(
          (_) async => const Right(PaymentStatus.error),
        );
      },
      act: (_) async => cubit.checkPurchaseStatus(
        createTestPayment(PaymentStatus.completed),
        () async {},
      ),
      expect: () =>
          [PurchasePaymentRejected(createTestPayment(PaymentStatus.error))],
    );

    blocTest(
      'should emit [Rejected] when status is Rejected',
      build: () => cubit,
      setUp: () {
        when(verifyPurchaseStatus(any)).thenAnswer(
          (_) async => const Right(PaymentStatus.refunded),
        );
      },
      act: (_) async => cubit.checkPurchaseStatus(
        createTestPayment(PaymentStatus.completed),
        () async {},
      ),
      expect: () =>
          [PurchasePaymentRejected(createTestPayment(PaymentStatus.completed))],
    );

    blocTest(
      'should emit [Rejected] when status is Refunded',
      build: () => cubit,
      setUp: () {
        when(verifyPurchaseStatus(any)).thenAnswer(
          (_) async => const Right(PaymentStatus.refunded),
        );
      },
      act: (_) async => cubit.checkPurchaseStatus(
        createTestPayment(PaymentStatus.completed),
        () async {},
      ),
      expect: () =>
          [PurchasePaymentRejected(createTestPayment(PaymentStatus.completed))],
    );
  });
}
