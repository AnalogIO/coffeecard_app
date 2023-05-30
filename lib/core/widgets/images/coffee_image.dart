import 'package:flutter/material.dart';

class CoffeeImage extends StatelessWidget {
  final int image;
  final double size;

  const CoffeeImage.fromId({required this.image, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: Image.asset('assets/profile_icons/coffee$image.png'),
    );
  }
}
