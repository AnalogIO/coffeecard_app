import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/features/shared/form.dart';
import 'package:coffeecard/features/voucher_code.dart';
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
        InputValidators.nonEmptyString(errorMessage: Strings.voucherEmpty),
      ],
      onSubmit: context.read<VoucherCubit>().redeemVoucherCode,
    );
  }
}
