import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/list_entry.dart';
import 'package:flutter/material.dart';

class SettingListEntry extends StatelessWidget {
  final String name;
  final Widget? valueWidget;
  final bool destructive;
  final bool disabled;
  final void Function()? onTap;

  const SettingListEntry({
    required this.name,
    this.disabled = false,
    this.onTap,
    this.valueWidget,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListEntry(
        backgroundColor: disabled ? AppColor.gray : null,
        onTap: disabled ? null : onTap,
        leftWidget: !destructive
            ? Text(name)
            : Text(name, style: const TextStyle(color: AppColor.error)),
        rightWidget:
            valueWidget == null ? const SizedBox.shrink() : valueWidget!,
      ),
    );
  }
}

class SettingDescription extends StatelessWidget {
  const SettingDescription({this.text, this.showArrow = true});

  final String? text;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (text != null)
          Flexible(
            child: Text(
              text!,
              style: AppTextStyle.settingValue,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        if (showArrow)
          const Icon(Icons.chevron_right, color: AppColor.secondary),
      ],
    );
  }
}
