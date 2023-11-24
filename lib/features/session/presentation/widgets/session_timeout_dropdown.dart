import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/dropdown.dart';
import 'package:coffeecard/features/session/presentation/cubit/session_timeout_cubit.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionTimeoutDropdown extends StatelessWidget {
  const SessionTimeoutDropdown();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SessionTimeoutCubit>()..load(),
      child: BlocBuilder<SessionTimeoutCubit, SessionTimeoutState>(
        builder: (context, state) => Dropdown<SessionTimeout>(
          loading: state is SessionTimeoutLoading,
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
