import 'dart:io';

import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/external/external_url_launcher.dart';
import 'package:coffeecard/features/purchase/data/models/payment_type.dart';
import 'package:coffeecard/features/purchase/data/repositories/payment_handler.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
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
  Future<Either<Failure, Payment>> initPurchase(
    int productId,
  ) async {
    final either = await remoteDataSource.initiatePurchase(
      productId,
      PaymentType.mobilepay,
    );

    return either.match(
      (_) => either,
      (payment) async {
        await launchMobilePay(payment);
        return either;
      },
    );
  }

  Future<void> launchMobilePay(Payment payment) async {
    final Uri mobilepayLink = Uri.parse(payment.deeplink);

    final canLaunch = await externalUrlLauncher.canLaunch(mobilepayLink);

    if (!canLaunch) {
      final Uri url = _getAppStoreUri();

      // MobilePay not installed, send user to appstore
      // TODO(marfavi): Instead of launching the appstore directly, show an
      //  error dialog to the user, with the option to download the app.
      // FIXME(marfavi): Create a github issue for this
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
