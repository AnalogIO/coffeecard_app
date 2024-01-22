import 'dart:async';

import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/bottom_modal_sheet_helper.dart';
import 'package:coffeecard/core/widgets/components/card.dart';
import 'package:coffeecard/core/widgets/components/slide_action.dart';
import 'package:coffeecard/features/product/menu_item_model.dart';
import 'package:coffeecard/features/receipt/presentation/cubit/receipt_cubit.dart';
import 'package:coffeecard/features/ticket/domain/entities/ticket.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:gap/gap.dart';

Future<T?> showSwipeTicketConfirm<T>({
  // The context is required to get cubits via context.read
  required BuildContext context,
  required Ticket ticket,
}) {
  return Navigator.of(context, rootNavigator: true).push(
    _HeroDialogRoute(
      builder: (_) => _ModalContent(context: context, ticket: ticket),
    ),
  );
}

class _ModalContent extends StatefulWidget {
  const _ModalContent({required this.context, required this.ticket});

  final BuildContext context;
  final Ticket ticket;

  @override
  State<_ModalContent> createState() => _ModalContentState();
}

class _ModalContentState extends State<_ModalContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _fadeBetweenAnimation;

  late Ticket _heroTag = widget.ticket;
  _TicketUseState _state = const _SelectProduct();

  late Option<MenuItem> _selectedMenuItem = widget.ticket.lastUsedMenuItem;

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

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BottomModalSheetHelper(
              children: [
                Text(
                  Strings.confirmSwipe,
                  style: AppTextStyle.explainerBright,
                ),
                Text(
                  Strings.tapHereToCancel,
                  style: AppTextStyle.explainerBright,
                ),
              ],
            ),
            Hero(
              tag: _heroTag,
              // SingleChildScrollView to avoid the temporary overflow
              // error during the hero animation.
              child: SingleChildScrollView(
                child: CardBase(
                  color: AppColors.ticket,
                  gap: 36,
                  top: titleWidget,
                  bottom: AnimatedSize(
                    alignment: Alignment.bottomCenter,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: actionWidget,
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
    const description = 'Select a product to spend your ticket on';

    return _wrapWithFadeTransition(
      _fadeInAnimation,
      child: CardTitle(
        title: Text(
          widget.ticket.product.name,
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
    final description = 'Claiming via ticket: ${widget.ticket.product.name}';

    return _wrapWithFadeTransition(
      _fadeBetweenAnimation,
      child: CardTitle(
        title: Text(menuItem.name, style: AppTextStyle.ownedTicket),
        description: Text(description, style: AppTextStyle.explainer),
      ),
    );
  }

  Widget get _selectProductAction {
    final dropdownItems = widget.ticket.product.eligibleMenuItems
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
                    hint: const Text('Select a product...'),
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
          const Gap(8),
          SlideAction(
            elevation: 0,
            text: Strings.useTicket,
            textStyle: AppTextStyle.buttonText.apply(color: AppColors.white),
            height: 56,
            sliderButtonIcon: const Icon(Icons.navigate_next, size: 48),
            sliderButtonIconPadding: 0,
            innerColor: AppColors.white,
            outerColor: AppColors.primary,
            onSubmit: () async {
              // Disable hero animation in the reverse direction
              setState(() => _heroTag = const Ticket.empty());
              final ticketCubit = widget.context.read<TicketsCubit>();
              final receiptCubit = widget.context.read<ReceiptCubit>();
              final productId = widget.ticket.product.id;
              await ticketCubit.useTicket(productId, menuItem.id);
              await receiptCubit.fetchReceipts();
            },
          ),
        ],
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
  Color get barrierColor => AppColors.scrim;

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
