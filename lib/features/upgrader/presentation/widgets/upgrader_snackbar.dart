import 'package:coffeecard/core/api_uri_constants.dart';
import 'package:coffeecard/core/external/external_url_launcher.dart';
import 'package:coffeecard/core/external/platform_service.dart';
import 'package:coffeecard/core/models/platform_type.dart';
import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class UpgraderSnackbar extends SnackBar {
  UpgraderSnackbar(BuildContext context)
      : super(
          content: RichText(
            text: TextSpan(
              style: AppTextStyle.loginExplainer,
              children: [
                const TextSpan(text: Strings.upgraderUpdateAvailable),
                TextSpan(
                  text: Strings.upgraderHere,
                  style: AppTextStyle.loginExplainer
                      .copyWith(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => handleClick(context),
                ),
                const TextSpan(text: Strings.upgraderToDownload),
              ],
            ),
          ),
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 200,
            left: 10,
            right: 10,
          ),
          backgroundColor: AppColors.secondary,
          duration: const Duration(seconds: 10),
          showCloseIcon: true,
        );
}

Future<void> handleClick(BuildContext context) async {
  final platformService = PlatformService();

  final Option<String> uri = switch (platformService.platformType()) {
    PlatformType.android => some(ApiUriConstants.playStoreUrl),
    PlatformType.iOS => some(ApiUriConstants.appStoreUrl),
    PlatformType.unknown => none(),
  };

  uri.map((uri) {
    ExternalUrlLauncher().launchUrlExternalApplication(
      context,
      Uri.parse(uri),
    );
  });
}
