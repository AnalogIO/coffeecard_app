import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/list_entry.dart';
import 'package:flutter/material.dart';

class SettingListEntry extends StatelessWidget {
  final String name;
  final Widget? valueWidget;
  final bool destructive;
  final void Function()? onTap;
  final ListEntrySide sideToExpand;

  const SettingListEntry({
    required this.name,
    this.onTap,
    this.valueWidget,
    this.destructive = false,
    this.sideToExpand = ListEntrySide.left,
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
      child: Text(
        name,
        style: destructive
            ? AppTextStyle.settingKeyDestructive
            : AppTextStyle.settingKey,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
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
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      child: ListEntry(
        onTap: _disabled ? null : onTap,
        sideToExpand: sideToExpand,
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
          Flexible(
            child: Text(
              text!,
              style: AppTextStyle.settingValue,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        if (showArrow)
          const Icon(Icons.chevron_right, color: AppColors.secondary),
      ],
    );
  }
}
