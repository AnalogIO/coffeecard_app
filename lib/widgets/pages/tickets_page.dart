import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/app_bar_title.dart';
import 'package:flutter/material.dart';

class TicketsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle('Tickets'),
      ),
      body: Center(
        child: Text(
          Strings.ticketsPageTestString,
          style: AppTextStyle.sectionTitle,
        ),
      ),
    );
  }
}
