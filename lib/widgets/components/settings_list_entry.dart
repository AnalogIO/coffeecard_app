import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/list_entry.dart';
import 'package:flutter/material.dart';

class SettingListEntry extends StatelessWidget {
  final String name;
  final Widget? valueWidget;
  final bool destructive;
  final void Function()? onTap;

  const SettingListEntry({
    required this.name,
    this.onTap,
    this.valueWidget,
    this.destructive = false,
  });

  bool get _disabled => onTap == null;

  Widget _opacity({required Widget child}) {
    return IgnorePointer(
      ignoring: _disabled,
      child: Opacity(
        opacity: _disabled ? 0.4 : 1,
        child: child,
      ),
    );
  }

  Widget get _leftWidget {
    return _opacity(
      child: destructive
          ? Text(name, style: const TextStyle(color: AppColor.error))
          : Text(name),
    );
  }

  Widget get _rightWidget {
    final valueWidget = this.valueWidget;
    return valueWidget != null
        ? IgnorePointer(child: _opacity(child: valueWidget))
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListEntry(
        onTap: _disabled ? null : onTap,
        leftWidget: _leftWidget,
        rightWidget: _rightWidget,
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
          Text(
            text!,
            style: AppTextStyle.settingValue,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        if (showArrow)
          const Icon(Icons.chevron_right, color: AppColor.secondary),
      ],
    );
  }
}
