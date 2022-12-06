import 'package:coffeecard/models/programme.dart';
import 'package:coffeecard/widgets/components/list_entry.dart';
import 'package:coffeecard/widgets/components/settings_list_entry.dart';
import 'package:flutter/material.dart';

class OccupationSelection extends StatelessWidget {
  final List<Programme> programmes;
  final Object? selected;
  final void Function(Programme) onTap;

  const OccupationSelection({
    required this.programmes,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: programmes.length,
      itemBuilder: (context, index) {
        programmes.sort((a, b) => a.fullName.compareTo(b.fullName));

        final programme = programmes[index];

        return SettingListEntry(
          sideToExpand: ListEntrySide.right,
          name: '${programme.fullName} (${programme.shortName})',
          valueWidget: Radio(
            value: programme.shortName,
            groupValue: selected,
            onChanged: (_) {},
          ),
          onTap: () => onTap(programme),
        );
      },
    );
  }
}
