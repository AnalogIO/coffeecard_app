import 'package:coffeecard/base/strings.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlExternalApplication(Uri url, BuildContext context) async {
  if (await canLaunchUrl(url)) {
    launchUrl(url, mode: LaunchMode.externalApplication);
    return;
  }

  if (context.mounted) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text(Strings.error),
          content: Text(Strings.cantLaunchUrl),
        );
      },
    );
  }
}
