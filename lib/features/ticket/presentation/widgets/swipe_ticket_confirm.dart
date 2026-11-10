import 'dart:async';

import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/card.dart';
import 'package:coffeecard/core/widgets/components/slide_action.dart';
import 'package:coffeecard/core/widgets/design/glass_surface.dart';
import 'package:coffeecard/features/product/menu_item_model.dart';
import 'package:coffeecard/features/product/product_model.dart';
import 'package:coffeecard/features/purchase/domain/entities/internal_payment_type.dart';
import 'package:coffeecard/features/purchase/presentation/widgets/purchase_overlay.dart';
import 'package:coffeecard/features/receipt/presentation/cubit/receipt_cubit.dart';
import 'package:coffeecard/features/ticket/domain/entities/ticket.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:gap/gap.dart';

Future<T?> showClaimSinglePerkConfirm<T>({
  required BuildContext context,
  required Product product,
}) {
  return _showSwipeTicketConfirm(
    context: context,
    ticket: Ticket(product: product, amountLeft: 1),
    heroTag: 'perk_${product.id}',
    isPerk: true,
  );
}

Future<T?> showSwipeTicketConfirm<T>({
  required BuildContext context,
  required Ticket ticket,
}) {
  return _showSwipeTicketConfirm(
    context: context,
    ticket: ticket,
    heroTag: 'ticket_${ticket.product.id}',
    isPerk: false,
  );
}

Future<T?> _showSwipeTicketConfirm<T>({
  // The context is required to get cubits via context.read
  required BuildContext context,
  required Ticket ticket,
  required String heroTag,
  required bool isPerk,
}) async {
  final lastUsedMenuItem = await ticket.product.lastUsedMenuItem.run();
  if (!context.mounted) return null;

  return Navigator.of(context, rootNavigator: true).push(
    _HeroDialogRoute(
      builder: (_) => _ModalContent(
        context: context,
        ticket: ticket,
        lastUsedMenuItem: lastUsedMenuItem,
        heroTag: heroTag,
        isPerk: isPerk,
      ),
    ),
  );
}

class _ModalContent extends StatefulWidget {
  const _ModalContent({
    required this.context,
    required this.ticket,
    required this.lastUsedMenuItem,
    required this.heroTag,
    required this.isPerk,
  });

  final BuildContext context;
  final Ticket ticket;
  final Option<MenuItem> lastUsedMenuItem;
  final String heroTag;
  final bool isPerk;

  @override
  State<_ModalContent> createState() => _ModalContentState();
}

class _ModalContentState extends State<_ModalContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _fadeBetweenAnimation;

  late String _heroTag = widget.heroTag;
  late final Product _product = widget.ticket.product;
  late Option<MenuItem> _selectedMenuItem = widget.lastUsedMenuItem;

  late _TicketUseState _state = switch (_product.eligibleMenuItems) {
    [final onlyMenuItem] => _ConfirmSwipe(onlyMenuItem),
    _ => const _SelectProduct(),
  };

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeInAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
    _fadeBetweenAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    // Start the animation
    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (titleWidget, actionWidget) = switch (_state) {
      _SelectProduct() => (
          _selectProductTitle,
          _selectProductAction,
        ),
      _ConfirmSwipe(:final menuItem) => (
          _confirmSwipeTitle(menuItem),
          _confirmSwipeAction(menuItem),
        ),
    };

    final left = widget.ticket.amountLeft;

    return SafeArea(
      minimum: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Hero(
              tag: _heroTag,
              // SingleChildScrollView to avoid the temporary overflow
              // error during the hero animation.
              child: SingleChildScrollView(
                child: Material(
                  type: MaterialType.transparency,
                  child: GlassSurface(
                    sheet: true,
                    radius: 40,
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          Strings.confirmSwipe.toUpperCase(),
                          style: AppTextStyle.ticketLabel,
                        ),
                        const Gap(8),
                        titleWidget,
                        if (!widget.isPerk) ...[
                          const Gap(16),
                          _TicketsLeftChange(before: left, after: left - 1),
                        ],
                        const Gap(16),
                        AnimatedSize(
                          alignment: Alignment.bottomCenter,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: actionWidget,
                        ),
                        const Gap(4),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            foregroundColor: AppColors.groundsDark,
                          ),
                          child: Text(
                            Strings.buttonCancel,
                            style: AppTextStyle.ui(
                              15,
                              weight: 500,
                              color: AppColors.groundsDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wrapWithFadeTransition(
    Animation<double> animation, {
    required Widget child,
  }) {
    return FadeTransition(opacity: animation, child: child);
  }

  Widget get _selectProductTitle {
    final description = switch (widget.isPerk) {
      true => 'Select a menu item to spend your perk on',
      false => 'Select a menu item to spend your ticket on',
    };

    return _wrapWithFadeTransition(
      _fadeInAnimation,
      child: CardTitle(
        title: Text(
          _product.name,
          style: AppTextStyle.ownedTicket,
        ),
        description: Text(
          description,
          style: AppTextStyle.explainer,
        ),
      ),
    );
  }

  Widget _confirmSwipeTitle(MenuItem menuItem) {
    final description = switch (widget.isPerk) {
      true => 'Claiming via perk: ${_product.name}',
      false => 'Claiming via ticket: ${_product.name}',
    };

    return _wrapWithFadeTransition(
      _fadeBetweenAnimation,
      child: CardTitle(
        title: Text(menuItem.name, style: AppTextStyle.ownedTicket),
        description: Text(description, style: AppTextStyle.explainer),
      ),
    );
  }

  Widget get _selectProductAction {
    final dropdownItems = _product.eligibleMenuItems
        .map((mi) => DropdownMenuItem(value: mi, child: Text(mi.name)))
        .toList();

    return _wrapWithFadeTransition(
      _fadeInAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    border: BorderDirectional(
                      bottom: BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                  ),
                  child: DropdownButton<MenuItem>(
                    hint: const Text('Select a menu item...'),
                    isExpanded: true,
                    value: _selectedMenuItem.toNullable(),
                    items: dropdownItems,
                    onChanged: (newItem) {
                      if (newItem != null) {
                        setState(() => _selectedMenuItem = Some(newItem));
                      }
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    focusColor: AppColors.primary,
                    underline: const SizedBox.shrink(),
                    dropdownColor: AppColors.white,
                  ),
                ),
              ),
              const Gap(16),
              IconButton.filledTonal(
                onPressed: _selectedMenuItem.match(
                  () => null,
                  (menuItem) => () async {
                    const duration = Duration(milliseconds: 200);
                    await _controller.animateBack(0, duration: duration);
                    await Future.delayed(const Duration(milliseconds: 100));
                    _controller.animateTo(1, duration: duration);
                    setState(() => _state = _ConfirmSwipe(menuItem));
                  },
                ),
                icon: const Icon(Icons.navigate_next),
                iconSize: 36,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _confirmSwipeAction(MenuItem menuItem) {
    return _wrapWithFadeTransition(
      _fadeBetweenAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SlideAction(
            elevation: 0,
            text: widget.isPerk ? Strings.claimPerk : Strings.useTicket,
            textStyle: AppTextStyle.buttonText.apply(color: AppColors.cream),
            height: 64,
            sliderButtonIcon: const Icon(
              Icons.arrow_forward_rounded,
              size: 28,
              color: AppColors.espresso,
            ),
            sliderButtonIconPadding: 14,
            innerColor: AppColors.cream,
            outerColor: AppColors.espresso,
            onSubmit: () async {
              // Disable hero animation in the reverse direction
              setState(() => _heroTag = '');

              if (widget.isPerk) {
                await showPurchaseOverlay(
                  context: widget.context,
                  product: _product,
                  paymentType: InternalPaymentType.free,
                );
              }

              if (!widget.context.mounted) return;

              final ticketCubit = widget.context.read<TicketsCubit>();
              final receiptCubit = widget.context.read<ReceiptCubit>();
              await _product.updateLastUsedMenuItem(menuItem).run();
              await ticketCubit.useTicket(_product.id, menuItem.id);
              await receiptCubit.fetchReceipts();
            },
          ),
        ],
      ),
    );
  }
}

/// "7 → 6": how many tickets are left before and after this swipe.
class _TicketsLeftChange extends StatelessWidget {
  const _TicketsLeftChange({required this.before, required this.after});

  final int before;
  final int after;

  @override
  Widget build(BuildContext context) {
    final figure = AppTextStyle.ticketFigure.copyWith(
      fontSize: 26,
      color: AppColors.roast,
    );
    return Semantics(
      label: Strings.ticketsLeftChange(before, after),
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Text('$before', style: figure),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: AppColors.grounds,
              ),
            ),
            Text('$after', style: figure),
            const Gap(16),
            Expanded(
              child: Text(
                Strings.ticketsLeftAfter,
                textAlign: TextAlign.right,
                style: AppTextStyle.ui(13, color: AppColors.groundsDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// original author https://stackoverflow.com/a/44404763
class _HeroDialogRoute<T> extends PageRoute<T> {
  _HeroDialogRoute({required this.builder});

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => AppColors.roast.withValues(alpha: .35);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  String? get barrierLabel => 'Cancel';
}

sealed class _TicketUseState {
  const _TicketUseState();
}

class _SelectProduct extends _TicketUseState {
  const _SelectProduct();
}

class _ConfirmSwipe extends _TicketUseState {
  const _ConfirmSwipe(this.menuItem);
  final MenuItem menuItem;
}
