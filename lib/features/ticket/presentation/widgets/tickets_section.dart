import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/coffee_card.dart';
import 'package:coffeecard/core/widgets/components/coffee_card_placeholder.dart';
import 'package:coffeecard/core/widgets/components/dialog.dart';
import 'package:coffeecard/core/widgets/components/error_section.dart';
import 'package:coffeecard/core/widgets/components/helpers/shimmer_builder.dart';
import 'package:coffeecard/core/widgets/components/loading_overlay.dart';
import 'package:coffeecard/core/widgets/components/section_title.dart';
import 'package:coffeecard/features/environment/domain/entities/environment.dart';
import 'package:coffeecard/features/environment/presentation/cubit/environment_cubit.dart';
import 'package:coffeecard/features/opening_hours/presentation/widgets/opening_hours_indicator.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/receipt_overlay.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class TicketSection extends StatelessWidget {
  const TicketSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(Strings.ticketsMyTickets),
            OpeningHoursIndicator(),
          ],
        ),
        BlocConsumer<TicketsCubit, TicketsState>(
          listenWhen: (previous, current) =>
              current is TicketUsing ||
              current is TicketUsed ||
              current is TicketsUseError,
          listener: (context, state) {
            if (state is TicketUsing) {
              if (Navigator.of(context, rootNavigator: true).canPop()) {
                // If a ticket was used from the buy
                // single drink flow, there is no swipe overlay

                // Remove the swipe overlay
                Navigator.of(context, rootNavigator: true).pop();
              }

              LoadingOverlay.show(context).ignore();
            }
            if (state is TicketUsed) {
              // Refresh or load user info (for updated rank stats)
              // (also refreshes leaderboard)
              context.read<UserCubit>().fetchUserDetails();

              final envState = context.read<EnvironmentCubit>().state;
              LoadingOverlay.hide(context);
              ReceiptOverlay.show(
                productName: state.receipt.productName,
                timeUsed: state.receipt.timeUsed,
                isTestEnvironment:
                    envState is EnvironmentLoaded && envState.env.isTest,
                status: state.receipt is PurchaseReceipt
                    ? (state.receipt as PurchaseReceipt)
                        .paymentStatus
                        .toString()
                    : Strings.swiped,
                context: context,
              ).ignore();
            }
            if (state is TicketsUseError) {
              LoadingOverlay.hide(context);
              appDialog(
                context: context,
                title: Strings.error,
                actions: [
                  TextButton(
                    child: const Text(Strings.buttonOK),
                    onPressed: () => closeAppDialog(context),
                  ),
                ],
                children: [Text(state.message, style: AppTextStyle.settingKey)],
                dismissible: true,
              );
            }
          },
          buildWhen: (previous, current) =>
              current is TicketsLoading ||
              current is TicketsLoaded ||
              current is TicketsLoadError,
          builder: (context, state) {
            if (state is TicketsLoading) {
              return const _CoffeeCardLoading();
            }
            if (state is TicketsLoaded) {
              // States extending this are also caught on this
              if (state.tickets.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: CoffeeCardPlaceholder(),
                );
              }
              return Column(
                children: state.tickets
                    .map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Hero(
                          tag: (p.productName, p.productId),
                          child: CoffeeCard(
                            title: p.productName,
                            amountOwned: p.count,
                            productId: p.productId,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            }
            if (state is TicketsLoadError) {
              return ErrorSection(
                error: state.message,
                retry: context.read<TicketsCubit>().getTickets,
              );
            }

            throw ArgumentError(this);
          },
        ),
        const Gap(4),
      ],
    );
  }
}

class _CoffeeCardLoading extends StatelessWidget {
  const _CoffeeCardLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerBuilder(
          showShimmer: true,
          builder: (context, colorIfShimmer) {
            return const IgnorePointer(
              child: CoffeeCard(
                amountOwned: -1,
                productId: -1,
                title: '',
              ),
            );
          },
        ),
      ],
    );
  }
}
