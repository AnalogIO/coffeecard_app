import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String title;

  const LoadingDialog({required this.title});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      title: Text(title),
      children: [
        Column(
          children: const [
            Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(color: AppColor.primary),
            ),
          ],
        ),
      ],
    );
  }
}
