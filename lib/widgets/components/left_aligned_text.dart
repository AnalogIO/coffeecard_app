import 'package:flutter/widgets.dart';

class LeftAlignedText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const LeftAlignedText(this.text, {this.style, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
