import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:flutter/material.dart';

class CardGeneric extends StatelessWidget {
  final List<Widget> children;
  final double? borderRadius;
  final double? height;
  final double? width;
  final double? padding;
  final Function()? onTap;

  const CardGeneric(
      {this.borderRadius,
      this.height,
      this.width,
      this.padding,
      this.onTap,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
      ),
      child: Tappable(
        padding: EdgeInsets.all(padding ?? 0),
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: Container(
            height: height,
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            )),
      ),
    );
  }
}
