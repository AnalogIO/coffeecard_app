import 'dart:convert';

import 'package:coffeecard/api_service.dart';
import 'package:coffeecard/widgets/popup_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum InternalPaymentType {
  mobilePay,
  applePay,
}

abstract class PaymentService {
  factory PaymentService(PaymentType type, BuildContext context) {
    switch (type) {
      case PaymentType.mobilePay:
        return MobilePayService(context);
      case PaymentType.applePay:
        throw UnimplementedError();
    }
  }

  Future<Payment> initPurchase(String productId);
  void invokeMobilePay(Payment po, int price);
  Future<PaymentStatus> verifyPurchaseOrRetry(
    String paymentId,
    String transactionId,
  );
}

class MobilePayService implements PaymentService {
  static const platform = MethodChannel('analog.mobilepay');

  final BuildContext context;

  MobilePayService(this.context) {
    platform.setMethodCallHandler(_callbackHandler);
  }

  Future<void> _callbackHandler(MethodCall call) async {
    switch (call.method) {
      case 'onSuccess':
        showDialog(
          context: context,
          builder: (context) {
            return const PopupCard(title: 'Success', content: 'Looks good?');
          },
        );
        break;
      case 'onFailure':
        showDialog(
          context: context,
          builder: (context) {
            return const PopupCard(title: 'Failure', content: 'Looks good?');
          },
        );
        break;
      case 'onCancel':
        showDialog(
          context: context,
          builder: (context) {
            return const PopupCard(title: 'Cancel', content: 'Looks good?');
          },
        );
        break;
    }
  }

  @override
  Future<Payment> initPurchase(String productId) async {
    // Call coffeecard API with productId
    //errors:
    //  networkerror: retry?
    //  else:         log and report error

    // Receive mobilepayId and deeplink from API
    final rsp = await APIService.postJSON(
      'MobilePay/initiate',
      {'productId': productId},
    );

    if (rsp.statusCode == 200) {
      final dynamic mobilePayInitiateJson = json.decode(rsp.body);
      final MobilePayInitiate mpi = MobilePayInitiate.fromJson(
        mobilePayInitiateJson as Map<String, dynamic>,
      );

      return Payment(paymentId: mpi.orderId, deeplink: '');
    }

    return Payment(
      paymentId: 'ae76a5ba-82e8-46d8-8431-6cbb3130b94a',
      deeplink: '',
    );
  }

  @override
  void invokeMobilePay(Payment po, int price) {
    // Open Mobilepay app with paymentId and deeplink
    platform.invokeMethod(
      'openMobilepay',
      {'price': price.toDouble(), 'orderId': po.paymentId},
    );
  }

  @override
  Future<PaymentStatus> verifyPurchaseOrRetry(
    String paymentId,
    String transactionId,
  ) async {
    // Call API endpoint, receive PaymentStatus
    final rsp = await APIService.postJSON(
      'MobilePay/complete',
      {'orderId': paymentId, 'transactionId': transactionId},
    );

    if (rsp.statusCode == 200) {
      final dynamic messageJson = json.decode(rsp.body);
      final String message =
          (messageJson as Map<String, dynamic>)['message'] as String;

      switch (message.toLowerCase()) {
        case 'successful completion':
          return PaymentStatus.completed;
        //FIXME: expand

        case 'waiting':
          {
            //retry X times?
            //  not success after X retries: return PaymentStatus.awaitingCompletionAfterRetry
          }
      }

      throw UnimplementedError();
    } else {
      return PaymentStatus.error;
    }
  }
}

class Payment {
  final String paymentId;
  final String deeplink;

  Payment({required this.paymentId, required this.deeplink});
}

enum PaymentStatus {
  completed, //payment is completed
  error, //mobilepay error
  waiting, //payment is not yet complete
  awaitingPayment, //user has not approved the purchase
  rejectedPayment, //user has rejected payment
  awaitingCompletionAfterRetry
}

class MobilePayInitiate {
  String orderId;

  MobilePayInitiate({required this.orderId});

  MobilePayInitiate.fromJson(Map<String, dynamic> json)
      : orderId = json['orderId'] as String;
}

class MobilePayComplete {
  String orderId;
  String transactionId;

  MobilePayComplete({required this.orderId, required this.transactionId});

  MobilePayComplete.fromJson(Map<String, dynamic> json)
      : orderId = json['orderId'] as String,
        transactionId = json['transactionId'] as String;
}
