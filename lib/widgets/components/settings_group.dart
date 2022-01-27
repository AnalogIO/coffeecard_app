import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/settings_list_entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';

class SettingsGroup extends StatelessWidget {
  final String title;
  final List<SettingListEntry> listItems;

  const SettingsGroup({required this.title, required this.listItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(16),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(title, style: AppTextStyle.sectionTitle),
        ),
        const Gap(8),
        Column(children: listItems)
      ],
    );
  }
}
