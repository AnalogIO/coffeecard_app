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
      Colors.yellow,
      Colors.red,
      Colors.blue,
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
