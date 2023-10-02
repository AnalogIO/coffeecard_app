import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

const List<String> list = ['2 hours', 'Never'];

class SessionTimeoutDropdown extends StatefulWidget {
  const SessionTimeoutDropdown();

  @override
  State<SessionTimeoutDropdown> createState() => _SessionTimeoutDropdownState();
}

class _SessionTimeoutDropdownState extends State<SessionTimeoutDropdown> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      underline: const SizedBox(),
      value: dropdownValue,
      alignment: Alignment.centerRight,
      style: AppTextStyle.settingValue,
      iconEnabledColor: AppColors.secondary,
      elevation: 16,
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
