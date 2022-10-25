import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffeecard/utils/encode_passcode.dart';
import 'package:coffeecard/widgets/components/helpers/shimmer_builder.dart';
import 'package:flutter/material.dart';

class GravatarImage extends StatelessWidget {
  final String hash;
  final double size;

  const GravatarImage.large({required this.hash}) : size = 100;

  const GravatarImage.small({required this.hash}) : size = 40;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageBuilder: (context, imageProvider) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      imageUrl:
          'https://gravatar.com/avatar/${hashMD5(hash)}?s=100&d=identicon',
      placeholder: (context, url) => ShimmerBuilder(
        showShimmer: true,
        builder: (context, colorIfShimmer) => CircleAvatar(
          backgroundColor: colorIfShimmer,
        ),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        radius: size / 2,
      ),
    );
  }
}
