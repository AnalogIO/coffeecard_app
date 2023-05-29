import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart'
    as swagger;

enum PaymentType {
  freepurchase,
  mobilepay,
}

extension PaymentTypeSwaggerConversion on PaymentType {
  swagger.PaymentType get swaggerEnum {
    return switch (this) {
      PaymentType.freepurchase => swagger.PaymentType.freepurchase,
      PaymentType.mobilepay => swagger.PaymentType.mobilepay,
    };
  }
}
