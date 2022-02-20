import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/voucher/voucher_cubit.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/voucher/redeem_voucher_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RedeemVoucherPage extends StatelessWidget {
  RedeemVoucherPage({Key? key}) : super(key: key);

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.redeemVoucherPageTitle,
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: RedeemVoucherTextField(),
      ),
    );
  }

  void submit(BuildContext context) {
    context.read<VoucherCubit>().redeemVoucher(_controller.text);
  }
}
