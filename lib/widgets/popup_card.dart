import 'package:coffeecard/widgets/analog_logo.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:flutter/material.dart';

class PopupCard extends StatelessWidget {
  final String title;
  final String content;

  const PopupCard({Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tappable(
      child: AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: const [
                      Text('This can be found'),
                      Text('again under receipts')
                    ],
                  ),
                  AnalogRecieptLogo()
                ],
              )
            ],
          )
        ],
        
      ),
      onTap: () => Navigator.pop(context),
    );
  }
}
