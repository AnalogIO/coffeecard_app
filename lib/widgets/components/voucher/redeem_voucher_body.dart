import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/voucher/voucher_cubit.dart';
import 'package:coffeecard/data/repositories/v1/voucher_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/continue_button.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:coffeecard/widgets/components/forms/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RedeemVoucherBody extends StatefulWidget {
  const RedeemVoucherBody();
  @override
  State<RedeemVoucherBody> createState() => _RedeemVoucherBodyState();
}

class _RedeemVoucherBodyState extends State<RedeemVoucherBody> {
  final _controller = TextEditingController();

  String? _error;
  String? get error => _error;
  set error(String? error) => setState(() => _error = error);

  void _submit(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isNotEmpty) context.read<VoucherCubit>().redeemVoucher(text);
  }

  Future<void> _listener(BuildContext context, VoucherState state) async {
    error = state is VoucherError ? state.error : null;
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VoucherCubit(sl.get<VoucherRepository>()),
      child: BlocConsumer<VoucherCubit, VoucherState>(
        listener: (context, state) async {
          await _listener(context, state);
        },
        builder: (context, state) {
          return Column(
            children: [
              AppTextField(
                label: Strings.voucherCode,
                hint: Strings.voucherHint,
                autofocus: true,
                onEditingComplete: () => _submit(context),
                onChanged: () => error = null,
                controller: _controller,
                error: _error,
                loading: state is VoucherLoading,
                readOnly: state is VoucherLoading,
              ),
              ContinueButton(onPressed: () => _submit(context), enabled: true)
            ],
          );
        },
      ),
    );
  }
}
