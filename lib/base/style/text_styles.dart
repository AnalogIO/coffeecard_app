import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_style_builder.dart';
import 'package:flutter/material.dart';

abstract final class AppTextStyle {
  static final _heading = TextStyleBuilder.heading;
  static final _body = TextStyleBuilder.body;
  static final _mono = TextStyleBuilder.mono;

  // Heading text
  static final pageTitle = _heading.size(24).color(AppColor.white).style;

  static final ownedTicket = _heading.size(24).color(AppColor.primary).style;

  static final loginTitle = _heading.size(18).color(AppColor.white).style;

  static final comingSoonShopCardTitle =
      loginTitle.copyWith(color: AppColor.gray);

  static final sectionTitle = loginTitle.copyWith(color: AppColor.primary);

  static final environmentNotifier =
      _heading.size(12).color(AppColor.primary).style;

  // Body text
  static final bottomNavBarLabel = _body.inheritSize().medium().style;

  static final price = _body.size(18).color(AppColor.primary).bold().style;

  static final _textFieldBase = _body.size(16).color(AppColor.primary);

  static final textField = _textFieldBase.style;

  static final textFieldBold = _textFieldBase.bold().style;

  static final openingHoursIndicator =
      _body.size(14).color(AppColor.primary).medium().style;

  static final settingKey = _body.size(14).color(AppColor.primary).style;

  static final settingKeyDestructive =
      settingKey.copyWith(color: AppColor.errorOnBright);

  static final settingValue = settingKey.copyWith(color: AppColor.secondary);

  static final receiptItemKey =
      _body.size(14).color(AppColor.primary).bold().style;

  static final receiptItemValue = settingKey;

  static final loginExplainer = settingKey.copyWith(color: AppColor.white);

  static final loginError = settingKey.copyWith(color: AppColor.errorOnDark);

  static final _buttonBase = _body.size(14).bold();

  static final buttonText = _buttonBase.color(AppColor.white).style;

  static final buttonTextDark = _buttonBase.color(AppColor.primary).style;

  static final buttonTextDisabled = _buttonBase.color(AppColor.gray).style;

  static final explainer = _body.size(12).color(AppColor.secondary).style;

  static final explainerBright = _body
      .size(12)
      .color(AppColor.white)
      .decoration(TextDecoration.none)
      .style;

  static final explainerDark = _body.size(12).color(AppColor.primary).style;

  static final explainerBold =
      _body.size(12).color(AppColor.secondary).bold().style;

  static final loginLink =
      _body.size(12).color(AppColor.white).underline().style;

  static final overLine = _body.size(12).color(AppColor.primary).style;

  static final shopCardOptionalLabel =
      _body.size(12).color(AppColor.ticket).bold().style;

  static final comingSoonLabel =
      shopCardOptionalLabel.copyWith(color: AppColor.gray);

  static final label = _body.size(11).color(AppColor.secondary).style;

  static final labelUnfocused = _body.size(11).color(AppColor.gray).style;

  static final explainerSmall = _body.size(11).color(AppColor.primary).style;

  // Mono text
  static final numpadDigit =
      _mono.size(33).color(AppColor.primary).bold().style;

  static final ticketsCount =
      _mono.size(24).color(AppColor.primary).bold().style;

  static final mixMatchTicketCount =
      _mono.size(18).color(AppColor.primary).bold().style;

  static final mixMatchTicketCountBright =
      _mono.size(18).color(AppColor.white).bold().style;

  static final numpadText = _mono.size(16).color(AppColor.primary).bold().style;

  static final leaderboardScore = _mono.size(14).color(AppColor.primary).style;

  static final receiptItemDate = _mono.size(12).color(AppColor.secondary).style;

  static final rankingNumber =
      _mono.size(12).color(AppColor.primary).bold().style;

  static final baristaButton =
      _body.size(12).color(AppColor.secondary).weight(500).style;
}
