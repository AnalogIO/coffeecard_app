import 'package:coffeecard/core/widgets/images/coffee_image.dart';
import 'package:flutter/material.dart';

class UserIcon extends StatelessWidget {
  const UserIcon.large({required this.id}) : size = 100;
  const UserIcon.small({required this.id}) : size = 40;

  final int id;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xffedd8e9),
      const Color(0xffbde7c6),
      const Color(0xffdce0c7),
      const Color(0xffcbc7eb),
      const Color(0xffc19b94),
      const Color(0xffa0dab5),
      const Color(0xfff8d9da),
      const Color(0xffCDFCF6),
      const Color(0xff92BA92),
      const Color(0xff86b4c3),
    ];
    final images = List.generate(9, (i) => i); // [0..8]

    final image = id % images.length;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors[id % colors.length],
          ),
        ),
        CoffeeImage.fromId(image: image, size: size),
      ],
    );
  }
}
