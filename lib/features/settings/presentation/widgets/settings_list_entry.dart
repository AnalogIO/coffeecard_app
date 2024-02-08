import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/list_entry.dart';
import 'package:flutter/material.dart';

class SettingListEntry extends StatelessWidget {
  final String name;
  final Widget? valueWidget;
  final bool destructive;
  final void Function()? onTap;
  final ListEntrySide sideToExpand;
  final bool overrideDisableBehaviour;

  const SettingListEntry({
    required this.name,
    this.onTap,
    this.valueWidget,
    this.destructive = false,
    this.sideToExpand = ListEntrySide.left,
    this.overrideDisableBehaviour = false,
  });

  bool get _disabled => onTap == null;

  Widget _opacity({required Widget child}) {
    final ignoring = _disabled && !overrideDisableBehaviour;

    return IgnorePointer(
      ignoring: ignoring,
      child: Opacity(
        opacity: ignoring ? 0.4 : 1,
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
        ? _opacity(child: valueWidget)
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListEntry(
        onTap: _disabled ? null : onTap,
        sideToExpand: sideToExpand,
        leftWidget: _leftWidget,
        rightWidget: _rightWidget,
      ),
    );
  }
}
