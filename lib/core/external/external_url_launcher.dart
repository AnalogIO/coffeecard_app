import 'package:coffeecard/core/strings.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launch;

class ExternalUrlLauncher {
  Future<bool> canLaunch(Uri uri) async => url_launch.canLaunchUrl(uri);

  Future<void> launch(Uri uri) async => url_launch.launchUrl(
        uri,
        mode: url_launch.LaunchMode.externalApplication,
      );

  Future<void> launchUrlExternalApplication(
    Uri url,
    BuildContext context,
  ) async {
    if (await canLaunch(url)) {
      final _ = launch(url);
      return;
    }

    if (context.mounted) {
      final _ = showDialog(
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
}
