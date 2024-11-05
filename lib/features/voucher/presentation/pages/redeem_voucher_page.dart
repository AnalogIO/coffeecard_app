import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/dialog.dart';
import 'package:coffeecard/core/widgets/components/loading_overlay.dart';
import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:coffeecard/features/voucher/presentation/cubit/voucher_cubit.dart';
import 'package:coffeecard/features/voucher/presentation/widgets/voucher_form.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RedeemVoucherPage extends StatelessWidget {
  const RedeemVoucherPage();

  static Route get route =>
      MaterialPageRoute(builder: (_) => const RedeemVoucherPage());

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.redeemVoucherPageTitle,
      applyPadding: true,
      body: BlocProvider(
        create: (_) => sl<VoucherCubit>(),
        child: BlocListener<VoucherCubit, VoucherState>(
          listener: (context, state) {
            if (state is VoucherLoading) {
              final _ = LoadingOverlay.show(context);
              return;
            }
            final _ = LoadingOverlay.hide(context);
            // Refresh tickets, so the user sees the redeemed ticket(s)
            // (we also refresh tickets in case of failure as a fail-safe)
            context.read<TicketsCubit>().refreshTickets();
            if (state is VoucherSuccess) return _onSuccess(context, state);
            if (state is VoucherError) return _onError(context, state);
          },
          child: const VoucherForm(),
        ),
      ),
    );
  }

  void _onSuccess(BuildContext context, VoucherSuccess state) {
    appDialog(
      context: context,
      title: Strings.voucherRedeemed,
      actions: [
        TextButton(
          child: const Text(Strings.buttonOK),
          onPressed: () {
            closeAppDialog(context);
            // Exits the voucher flow
            Navigator.pop(context);
          },
        ),
      ],
      children: [
        Text(
          Strings.voucherYouRedeemedProducts(
            state.redeemedVoucher.numberOfTickets,
            state.redeemedVoucher.productName,
          ),
          style: AppTextStyle.settingKey,
        ),
      ],
      dismissible: true,
    );
  }

  void _onError(BuildContext context, VoucherError state) {
    appDialog(
      context: context,
      title: Strings.error,
      children: [Text(state.error, style: AppTextStyle.settingKey)],
      actions: [
        TextButton(
          child: const Text(Strings.buttonOK),
          onPressed: () => closeAppDialog(context),
        ),
      ],
      dismissible: true,
    );
  }
}
