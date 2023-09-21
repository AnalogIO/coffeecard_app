import 'package:coffeecard/core/input_validator.dart';
import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/features/form/presentation/widgets/form.dart';
import 'package:coffeecard/features/voucher/presentation/cubit/voucher_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VoucherForm extends StatelessWidget {
  const VoucherForm();

  @override
  Widget build(BuildContext context) {
    return FormBase(
      label: Strings.voucherCode,
      hint: Strings.voucherHint,
      inputValidators: [
        InputValidators.nonEmptyString(
          errorMessage: Strings.voucherEmpty,
        ),
      ],
      onSubmit: context.read<VoucherCubit>().redeemVoucher,
    );
  }
}
