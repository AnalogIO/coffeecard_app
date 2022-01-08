import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:flutter/cupertino.dart';

class SettingListItem extends StatelessWidget {
  final String name;
  final Widget? valueWidget;
  final bool destructive;
  final void Function() onTap;

  const SettingListItem({
    required this.name,
    required this.onTap,
    this.valueWidget,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tappable(
      color: AppColor.white,
      border: const Border(bottom: BorderSide(color: AppColor.lightGray)),
      onTap: onTap,
      child: SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (destructive == false)
                Text(name)
              else
                Text(name, style: const TextStyle(color: AppColor.error)),
              if (valueWidget == null) Container() else valueWidget!,
            ],
          ),
        ),
      ),
    );
  }
}
