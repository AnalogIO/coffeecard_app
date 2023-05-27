import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/core/widgets/list_entry.dart';
import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:coffeecard/features/settings/presentation/widgets/settings_list_entry.dart';
import 'package:coffeecard/widgets/components/section_title.dart';
import 'package:coffeecard/widgets/components/tickets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// A form for selecting an occupation.
///
/// Does not use the `FormBase` widget, but acts as a form with an optional
/// continue button.
///
/// If [onContinue] is provided, a continue button will be shown at the bottom.
class OccupationForm extends StatelessWidget {
  final Occupation? selectedOccupation;
  final List<Occupation> occupations;
  final Function(Occupation) onChange;
  final Function(Occupation)? onContinue;

  const OccupationForm({
    required this.selectedOccupation,
    required this.occupations,
    required this.onChange,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              const Gap(16),
              const SectionTitle(Strings.registerOccupationTitle),
              const Gap(16),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                child: Column(
                  children: occupations
                      .map(
                        (occupation) => OccupationListEntry(
                          occupation: occupation,
                          selected: selectedOccupation,
                          onTap: onChange,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        if (onContinue != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RoundedButton(
              text: Strings.buttonContinue,
              onTap: selectedOccupation != null
                  ? () => onContinue!(selectedOccupation!)
                  : null,
            ),
          ),
      ],
    );
  }
}

class OccupationSelection extends StatelessWidget {
  final List<Occupation> occupations;
  final Occupation? selectedOccupation;
  final void Function(Occupation) onTap;

  const OccupationSelection({
    required this.selectedOccupation,
    required this.occupations,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    occupations.sort((a, b) => a.fullName.compareTo(b.fullName));

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      child: Column(
        children: occupations
            .map(
              (occupation) => OccupationListEntry(
                occupation: occupation,
                selected: selectedOccupation,
                onTap: onTap,
              ),
            )
            .toList(),
      ),
    );
  }
}

class OccupationListEntry extends StatelessWidget {
  const OccupationListEntry({
    required this.occupation,
    required this.selected,
    required this.onTap,
  });

  final Occupation occupation;
  final Occupation? selected;
  final void Function(Occupation) onTap;

  @override
  Widget build(BuildContext context) {
    return SettingListEntry(
      sideToExpand: ListEntrySide.right,
      name: '${occupation.fullName} (${occupation.shortName})',
      valueWidget: Radio(
        value: occupation,
        groupValue: selected,
        // On tap handler is set on the whole list entry; ignore the tap here
        // ignore: no-empty-block
        onChanged: (_) {},
      ),
      onTap: () => onTap(occupation),
    );
  }
}
