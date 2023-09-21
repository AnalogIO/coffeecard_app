import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// Based on https://stackoverflow.com/a/62341566
class UnorderedListBuilder extends StatelessWidget {
  const UnorderedListBuilder({
    required this.builder,
    required this.texts,
    this.gap = 6,
  });
  final Widget Function(String) builder;
  final List<String> texts;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final widgetList = <Widget>[];
    for (final text in texts) {
      widgetList.add(_UnorderedListItem(builder, text));
      widgetList.add(Gap(gap));
    }
    return Column(children: widgetList);
  }
}

class _UnorderedListItem extends StatelessWidget {
  const _UnorderedListItem(this.textBuilder, this.text);
  final Widget Function(String) textBuilder;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        textBuilder('•  '),
        Expanded(
          child: textBuilder(text),
        ),
      ],
    );
  }
}
