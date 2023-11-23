import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/dropdown.dart';
import 'package:coffeecard/features/settings/presentation/cubit/session_timeout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionTimeoutDropdown extends StatelessWidget {
  const SessionTimeoutDropdown();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SessionTimeoutCubit(),
      child: BlocBuilder<SessionTimeoutCubit, SessionTimeoutState>(
        builder: (context, state) => Dropdown<SessionTimeout>(
          loading: false,
          textStyle: AppTextStyle.settingValue,
          dropdownColor: AppColors.primary,
          value: context.read<SessionTimeoutCubit>().selected(),
          items: entries
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.$1),
                ),
              )
              .toList(),
          onChanged: (value) =>
              context.read<SessionTimeoutCubit>().setSelected(value!),
        ),
      ),
    );
  }
}
