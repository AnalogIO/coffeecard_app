import 'package:coffeecard/core/widgets/images/coffee_image.dart';
import 'package:flutter/material.dart';

class UserIcon extends StatelessWidget {
  const UserIcon.large({required this.userId, this.icon, this.background})
      : size = 100;

  const UserIcon.small({required this.userId, this.icon, this.background})
      : size = 40;

  static List<Color> getColors() {
    return colors;
  }

  static final colors = [
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

  final int userId;
  final double size;
  final int? icon;
  final int? background;

  @override
  Widget build(BuildContext context) {
    final images = List.generate(10, (i) => i); // [0..9]

    final image = icon ?? userId % images.length;
    final color = background ?? userId % colors.length;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors[color],
          ),
        ),
        CoffeeImage.fromId(image: image, size: size),
      ],
    );
  }
}
