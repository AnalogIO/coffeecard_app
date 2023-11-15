import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/features/authentication/presentation/cubits/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const List<(String, Duration?)> entries = [
  ('2 seconds', Duration(seconds: 2)),
  ('2 hours', Duration(hours: 2)),
  ('Never', null),
];

class SessionTimeoutDropdown extends StatefulWidget {
  final Duration? selectedDuration;

  const SessionTimeoutDropdown({required this.selectedDuration});

  @override
  State<SessionTimeoutDropdown> createState() => _SessionTimeoutDropdownState();
}

class _SessionTimeoutDropdownState extends State<SessionTimeoutDropdown> {
  late (String, Duration?) dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue =
        entries.firstWhere((element) => element.$2 == widget.selectedDuration);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<(String, Duration?)>(
      underline: const SizedBox(),
      value: dropdownValue,
      alignment: Alignment.centerRight,
      style: AppTextStyle.settingValue,
      iconEnabledColor: AppColors.secondary,
      onChanged: ((String, Duration?)? value) => setState(() {
        context.read<AuthenticationCubit>().saveSessionTimeout(value!.$2);
        dropdownValue = value;
      }),
      items: entries
          .map(
            (e) => DropdownMenuItem<(String, Duration?)>(
              value: e,
              child: Text(e.$1),
            ),
          )
          .toList(),
    );
  }
}
