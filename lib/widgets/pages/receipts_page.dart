// import 'package:coffeecard/widgets/text_field.dart';
import 'package:flutter/material.dart';

class ReceiptsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(),
            // AppTextField(),
            // AppTextField(),
            // AppTextField(
            //   disabled: true,
            //   label: "I'm disabled!",
            //   value: 'Cant touch this',
            // ),
            // AppTextField(
            //   value: 'Default value?',
            // ),
          ],
        ),
      ),
    );
  }
}
