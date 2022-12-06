import 'package:coffeecard/models/occupation.dart';
import 'package:coffeecard/widgets/components/list_entry.dart';
import 'package:coffeecard/widgets/components/settings_list_entry.dart';
import 'package:flutter/material.dart';

class OccupationSelection extends StatelessWidget {
  final List<Occupation> occupations;
  final Object? selected;
  final void Function(Occupation) onTap;

  const OccupationSelection({
    required this.occupations,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: occupations.length,
      itemBuilder: (context, index) {
        occupations.sort((a, b) => a.fullName.compareTo(b.fullName));

        final occupation = occupations[index];

        return SettingListEntry(
          sideToExpand: ListEntrySide.right,
          name: '${occupation.fullName} (${occupation.shortName})',
          valueWidget: Radio(
            value: occupation.shortName,
            groupValue: selected,
            onChanged: (_) {},
          ),
          onTap: () => onTap(occupation),
        );
      },
    );
  }
}
