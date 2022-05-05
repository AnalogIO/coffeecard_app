import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/cubits/tickets/tickets_cubit.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/widgets/components/helpers/shimmer_builder.dart';
import 'package:coffeecard/widgets/components/loading_overlay.dart';
import 'package:coffeecard/widgets/components/receipt/receipt_overlay.dart';
import 'package:coffeecard/widgets/components/tickets/coffee_card.dart';
import 'package:coffeecard/widgets/components/tickets/coffee_card_placeholder.dart';
import 'package:coffeecard/widgets/components/tickets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class TicketSection extends StatelessWidget {
  const TicketSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocConsumer<TicketsCubit, TicketsState>(
          listener: (context, state) {
            if (state is TicketUsing) {
              // Remove the swipe overlay
              Navigator.of(context, rootNavigator: true).pop();
              // TODO consider using a nicer loading indicator
              LoadingOverlay.of(context).show();
            } else if (state is TicketUsed) {
              // Refresh or load user info (for updated rank stats)
              // (also refreshes leaderboard)
              context.read<UserCubit>().fetchUserDetails();

              final envState = context.read<EnvironmentCubit>().state;
              LoadingOverlay.of(context).hide();
              ReceiptOverlay.of(context).show(
                receipt: state.receipt,
                isTestEnvironment:
                    envState is EnvironmentLoaded && envState.isTestEnvironment,
              );
            }
          },
          builder: (context, state) {
            if (state is TicketsLoading) {
              return const _CoffeeCardLoading();
            } else if (state is TicketsLoaded) {
              // States extending this are also caught on this
              if (state.tickets.isEmpty) {
                return const CoffeeCardPlaceholder();
              }
              return Column(
                children: state.tickets
                    .map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Hero(
                          tag: p.productId,
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
            } else if (state is TicketsError) {
              return Column(
                children: [
                  Text('${Strings.error}: ${state.message}'),
                  const Gap(8),
                  RoundedButton(
                    text: Strings.buttonTryAgain,
                    onTap: context.read<TicketsCubit>().getTickets,
                  ),
                ],
              );
            }

            throw MatchCaseIncompleteException(this);
          },
        ),
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
