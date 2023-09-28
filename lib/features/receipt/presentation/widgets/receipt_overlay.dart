import 'package:coffeecard/core/external/screen_brightness.dart';
import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/helpers/responsive.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/receipt_card.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ReceiptOverlay {
  static final ScreenBrightness screenBrightness = sl();

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Future<void> show({
    required String productName,
    required DateTime timeUsed,
    required bool isTestEnvironment,
    required String status,
    required BuildContext context,
  }) async {
    await ScreenBrightness().setScreenBrightness(1);
    if (context.mounted) {
      final _ = await showDialog(
        context: context,
        barrierColor: AppColors.scrim,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(deviceIsSmall(context) ? 24 : 48),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReceiptCard(
                    productName: productName,
                    time: timeUsed,
                    isInOverlay: true,
                    isTestEnvironment: isTestEnvironment,
                    status: status,
                  ),
                  const Gap(12),
                  Text(
                    Strings.receiptTapAnywhereToDismiss,
                    style: AppTextStyle.explainerBright,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    await ScreenBrightness().resetScreenBrightness();
  }
}
