import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/helpers/tappable.dart';
import 'package:coffeecard/core/widgets/components/rounded_button.dart';
import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/core/widgets/images/coffee_image.dart';
import 'package:coffeecard/features/settings/presentation/widgets/user_icon.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

final images = List.generate(9, (i) => i)
    .map((image) => CoffeeImage.fromId(image: image, size: 40))
    .toList();

final colors = UserIcon.getColors()
    .map((c) => Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(shape: BoxShape.circle, color: c),
        ))
    .toList();

class ChangeProfilePicturePage extends StatefulWidget {
  const ChangeProfilePicturePage();

  static Route get route {
    return MaterialPageRoute(builder: (_) => const ChangeProfilePicturePage());
  }

  @override
  State<ChangeProfilePicturePage> createState() =>
      _ChangeProfilePicturePageState();
}

class _ChangeProfilePicturePageState extends State<ChangeProfilePicturePage> {
  int? selectedImage;
  int? selectedColor;

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.changeProfilePicture,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          Text(
            Strings.chooseIcon,
            style: AppTextStyle.sectionTitle,
            textAlign: TextAlign.center,
          ),
          const Gap(16),
          GridView.count(
            crossAxisCount: 5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: images.map((image) {
              final index = image.image;
              final isSelected = selectedImage == index;
              return Tappable(
                onTap: () => setState(() {
                  selectedImage = index;
                }),
                borderRadius: BorderRadius.circular(32),
                borderColor: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                child: image,
              );
            }).toList(),
          ),
          const Gap(16),
          Text(
            Strings.chooseColor,
            style: AppTextStyle.sectionTitle,
            textAlign: TextAlign.center,
          ),
          const Gap(16),
          GridView.count(
            crossAxisCount: 5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: colors.asMap().entries.map((entry) {
              final isSelected = selectedColor == entry.key;
              return Tappable(
                  onTap: () => setState(() {
                        selectedColor = entry.key;
                      }),
                  borderRadius: BorderRadius.circular(32),
                  borderColor: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  child: entry.value);
            }).toList(),
          ),
          const Gap(80),
          RoundedButton(
            text: Strings.buttonContinue,
            onTap: (selectedImage != null && selectedColor != null)
                ? () {
                    context.read<UserCubit>().setUserProfileImage(
                        profileIconId: selectedImage!, colorId: selectedColor!);
                    Navigator.of(context).pop();
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
