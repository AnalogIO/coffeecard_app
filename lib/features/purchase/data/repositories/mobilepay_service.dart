import 'dart:io';

import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/extensions/either_extensions.dart';
import 'package:coffeecard/core/external/external_url_launcher.dart';
import 'package:coffeecard/features/purchase/data/repositories/payment_handler.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/utils/api_uri_constants.dart';
import 'package:fpdart/fpdart.dart';

class MobilePayService extends PaymentHandler {
  final ExternalUrlLauncher externalUrlLauncher;

  MobilePayService({
    required this.externalUrlLauncher,
    required super.remoteDataSource,
    required super.buildContext,
  });
  @override
  Future<Either<Failure, Payment>> initPurchase(int productId) async {
    final either = await remoteDataSource
        .initiatePurchase(productId, PaymentType.mobilepay)
        .bindFuture(
          (purchase) => Payment(
            id: purchase.id,
            status: PaymentStatus.awaitingPayment,
            deeplink: MobilePayPaymentDetails.fromJson(purchase.paymentDetails)
                .mobilePayAppRedirectUri,
            purchaseTime: purchase.dateCreated,
            price: purchase.totalAmount,
            productId: purchase.productId,
            productName: purchase.productName,
          ),
        );

    return either.fold(
      (error) => Left(error),
      (payment) async {
        await launchMobilePay(payment);

        return Right(payment);
      },
    );
  }

  Future<void> launchMobilePay(Payment payment) async {
    final Uri mobilepayLink = Uri.parse(payment.deeplink);

    final canLaunch = await externalUrlLauncher.canLaunch(mobilepayLink);

    if (!canLaunch) {
      final Uri url = _getAppStoreUri();

      // MobilePay not installed, send user to appstore
      if (buildContext.mounted) {
        await externalUrlLauncher.launchUrlExternalApplication(
          url,
          buildContext,
        );
      }

      return;
    }

    await externalUrlLauncher.launch(mobilepayLink);
  }

  Uri _getAppStoreUri() {
    if (Platform.isAndroid) {
      return ApiUriConstants.mobilepayAndroid;
    } else if (Platform.isIOS) {
      return ApiUriConstants.mobilepayIOS;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
