import 'package:coffeecard/features/purchase/data/models/payment_type.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart'
    as swagger;

class PaymentModel extends Payment {
  const PaymentModel({
    required super.id,
    required super.price,
    required super.purchaseTime,
    required super.status,
    required super.deeplink,
    required super.productId,
    required super.productName,
  });

  factory PaymentModel.fromDto(
    swagger.InitiatePurchaseResponse dto,
    PaymentType paymentType,
  ) {
    return PaymentModel(
      id: dto.id,
      price: dto.totalAmount,
      purchaseTime: dto.dateCreated,
      status: _paymentStatus(dto),
      deeplink: _deeplink(dto, paymentType),
      productId: dto.productId,
      productName: dto.productName,
    );
  }

  static PaymentStatus _paymentStatus(swagger.InitiatePurchaseResponse dto) {
    return PaymentStatus.fromPurchaseStatus(
      swagger.purchaseStatusFromJson(dto.purchaseStatus),
    );
  }

  static String _deeplink(
    swagger.InitiatePurchaseResponse dto,
    PaymentType paymentType,
  ) {
    switch (paymentType) {
      case PaymentType.freepurchase:
        return '';
      case PaymentType.mobilepay:
        final json = dto.paymentDetails as Map<String, dynamic>;
        return swagger.MobilePayPaymentDetails.fromJson(json)
            .mobilePayAppRedirectUri;
    }
  }
}
