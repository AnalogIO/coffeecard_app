import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/widgets/components/list_entry.dart';
import 'package:flutter/cupertino.dart';

class SettingListEntry extends StatelessWidget {
  final String name;
  final Widget? valueWidget;
  final bool destructive;
  final void Function() onTap;

  const SettingListEntry({
    required this.name,
    required this.onTap,
    this.valueWidget,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListEntry(
        onTap: onTap,
        leftWidget: !destructive
            ? Text(name)
            : Text(name, style: const TextStyle(color: AppColor.error)),
        rightWidget:
            valueWidget == null ? const SizedBox.shrink() : valueWidget!,
      ),
    );
  }
}
