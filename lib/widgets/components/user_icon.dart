import 'package:coffeecard/widgets/components/images/coffee_image.dart';
import 'package:flutter/material.dart';

class GravatarImage extends StatelessWidget {
  final int id;
  final double size;

  const GravatarImage.large({required this.id}) : size = 100;

  const GravatarImage.small({required this.id}) : size = 40;

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
