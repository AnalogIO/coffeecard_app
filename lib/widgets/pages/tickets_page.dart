import 'package:flutter/material.dart';

import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';

class TicketsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(Strings.ticketsPageTestString, style: AppTextStyle.sectionTitle),
    );
  }
}
