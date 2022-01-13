import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/fonts.dart';
import 'package:flutter/material.dart';

abstract class AppTextStyle {
  // Heading text
  static final TextStyle pageTitle = TextStyle(
    color: AppColor.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.heading,
  );
  static final TextStyle ownedTicket = TextStyle(
    color: AppColor.primary,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.heading,
  );
  static final TextStyle loginTitle = TextStyle(
    color: AppColor.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.heading,
  );
  static final TextStyle sectionTitle = TextStyle(
    color: AppColor.primary,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.heading,
  );

  // Body text
  static const TextStyle medium = TextStyle(
    fontWeight: FontWeight.w500,
  );
  static final TextStyle price = TextStyle(
    color: AppColor.primary,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.body,
  );
  static final TextStyle textField = TextStyle(
    color: AppColor.primary,
    fontSize: 16,
    fontFamily: AppFont.body,
  );
  static final TextStyle textFieldBold = TextStyle(
    color: AppColor.primary,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.body,
  );
  static final TextStyle settingKey = TextStyle(
    color: AppColor.primary,
    fontSize: 14,
    fontFamily: AppFont.body,
  );
  static final TextStyle settingKeyDestructive = TextStyle(
    color: AppColor.error,
    fontSize: 14,
    fontFamily: AppFont.body,
  );
  static final TextStyle settingValue = TextStyle(
    color: AppColor.secondary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: AppFont.body,
  );
  static final TextStyle recieptItemKey = TextStyle(
    color: AppColor.primary,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.body,
  );
  static final TextStyle recieptItemValue = TextStyle(
    color: AppColor.primary,
    fontSize: 14,
    fontFamily: AppFont.body,
  );
  static final TextStyle loginExplainer = TextStyle(
    color: AppColor.white,
    fontSize: 14,
    fontFamily: AppFont.body,
  );
  static final TextStyle loginError = TextStyle(
    color: AppColor.error,
    fontSize: 14,
    fontFamily: AppFont.body,
  );
  static final TextStyle buttonText = TextStyle(
    color: AppColor.white,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.body,
  );
  static final TextStyle buttonTextDisabled = TextStyle(
    color: AppColor.gray,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.body,
  );
  static final TextStyle explainer = TextStyle(
    color: AppColor.secondary,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: AppFont.body,
  );
  static final TextStyle explainerBright = TextStyle(
    color: AppColor.white,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: AppFont.body,
  );
  static final TextStyle explainerBold = TextStyle(
    color: AppColor.secondary,
    fontSize: 12,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.body,
  );
  static final TextStyle loginLink = TextStyle(
    color: AppColor.white,
    fontSize: 12,
    decoration: TextDecoration.underline,
    fontFamily: AppFont.body,
  );
  static final TextStyle explainerDark = TextStyle(
    color: AppColor.primary,
    fontSize: 12,
    fontFamily: AppFont.body,
  );
  static final TextStyle label = TextStyle(
    color: AppColor.secondary,
    fontSize: 11,
    fontFamily: AppFont.body,
  );
  static final TextStyle labelUnfocused = TextStyle(
    color: AppColor.gray,
    fontSize: 11,
    fontFamily: AppFont.body,
  );
  static final TextStyle explainerSmall = TextStyle(
    color: AppColor.primary,
    fontSize: 9,
    fontFamily: AppFont.body,
  );

  // Mono text
  static const TextStyle numpadDigit = TextStyle(
    color: AppColor.primary,
    fontSize: 33,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.mono,
  );
  static const TextStyle ticketsCount = TextStyle(
    color: AppColor.primary,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.mono,
  );
  static const TextStyle mixMatchTicketCount = TextStyle(
    color: AppColor.primary,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.mono,
  );
  static const TextStyle mixMatchTicketCountBright = TextStyle(
    color: AppColor.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.mono,
  );
  static const TextStyle numpadText = TextStyle(
    color: AppColor.primary,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.mono,
  );
  static const TextStyle leaderboardScore = TextStyle(
    color: AppColor.primary,
    fontSize: 14,
    fontFamily: AppFont.mono,
  );
  static const TextStyle recieptItemDate = TextStyle(
    color: AppColor.secondary,
    fontSize: 12,
    fontFamily: AppFont.mono,
  );
  static const TextStyle rankingNumber = TextStyle(
    color: AppColor.primary,
    fontSize: 12,
    fontWeight: FontWeight.bold,
    fontFamily: AppFont.mono,
  );
}
