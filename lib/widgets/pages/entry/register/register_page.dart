import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/section_title.dart';
import 'package:flutter/material.dart';

abstract class RegisterPage extends StatelessWidget {
  final String appBarTitle;
  final Widget body;
  final String? title;

  const RegisterPage({
    required this.appBarTitle,
    required this.body,
    this.title,
  });

  Widget get _body {
    if (title == null) return body;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Null check added because properties can't be promoted.
        SectionTitle.register(title!),
        body,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(title: Text(appBarTitle, style: AppTextStyle.pageTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _body,
      ),
    );
  }
}
