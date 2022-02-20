import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/voucher/voucher_cubit.dart';
import 'package:coffeecard/data/repositories/v1/voucher_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:coffeecard/widgets/components/forms/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RedeemVoucherTextField extends StatefulWidget {
  const RedeemVoucherTextField();
  @override
  State<RedeemVoucherTextField> createState() => _RedeemVoucherTextFieldState();
}

class _RedeemVoucherTextFieldState extends State<RedeemVoucherTextField> {
  final _controller = TextEditingController();
  bool _loading = false;

  String? _error;
  String? get error => _error;
  set error(String? error) => setState(() => _error = error);

  void submit(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isNotEmpty) context.read<VoucherCubit>().redeemVoucher(text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VoucherCubit(sl.get<VoucherRepository>()),
      child: BlocConsumer<VoucherCubit, VoucherState>(
        listener: (context, state) async {
          if (_loading && state is! VoucherLoading) {
            setState(() => _loading = false);
          } else if (!_loading && state is VoucherLoading) {
            setState(() => _loading = true);
          }
          error = (state is VoucherError) ? state.error : null;
          if (state is VoucherSuccess) {
            await appDialog(
              context: context,
              title: Strings.voucherRedeemed,
              actions: [
                TextButton(
                  child: const Text(Strings.buttonOK),
                  onPressed: () => closeAppDialog(context),
                ),
              ],
              children: [
                Text(
                  '${Strings.youRedeemed} ${state.redeemedVoucher.numberOfTickets} ${state.redeemedVoucher.productName}!',
                  style: AppTextStyle.settingKey,
                )
              ],
              dismissible: true,
            );
            if (mounted) Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return AppTextField(
            label: Strings.voucherCode,
            hint: Strings.voucherHint,
            autofocus: true,
            onEditingComplete: () => submit(context),
            onChanged: () => error = null,
            controller: _controller,
            error: _error,
            loading: _loading,
            readOnly: _loading,
          );
        },
      ),
    );
  }
}
