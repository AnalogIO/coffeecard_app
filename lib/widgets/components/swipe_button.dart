import 'package:flutter/material.dart';

class SwipeButton extends StatefulWidget {
  const SwipeButton({ Key? key }) : super(key: key);

  @override
  _SwipeButtonState createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<SwipeButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}
