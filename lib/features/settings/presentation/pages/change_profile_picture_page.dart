import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/core/widgets/images/coffee_image.dart';
import 'package:coffeecard/features/settings/presentation/widgets/user_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

final images = List.generate(9, (i) => i)
    .map((image) => CoffeeImage.fromId(image: image, size: 40));

final colors = UserIcon.getColors().map((c) => Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(shape: BoxShape.circle, color: c),
    ));

class ChangeProfilePicturePage extends StatelessWidget {
  const ChangeProfilePicturePage();

  static Route get route {
    return MaterialPageRoute(builder: (_) => const ChangeProfilePicturePage());
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.changeProfilePicture,
      body: ListView(
        children: [
          Text(
            Strings.chooseIcon,
            style: AppTextStyle.sectionTitle,
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          ...images,
          const Gap(8),
          Text(
            Strings.chooseColor,
            style: AppTextStyle.sectionTitle,
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          ...colors
        ],
      ),
    );
  }
}
