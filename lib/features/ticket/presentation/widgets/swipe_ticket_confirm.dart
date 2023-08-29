import 'dart:async';

import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/features/receipt/presentation/cubit/receipt_cubit.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:coffeecard/widgets/components/card.dart';
import 'package:coffeecard/widgets/components/tickets/bottom_modal_sheet_helper.dart';
import 'package:coffeecard/widgets/components/tickets/slide_to_act.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<T?> showSwipeTicketConfirm<T>({
  required BuildContext context,
  required String productName,
  required int amountOwned,
  required int productId,
}) {
  return Navigator.of(context, rootNavigator: true).push(
    _HeroDialogRoute(
      builder: (_) {
        return _ModalContent(
          context: context,
          productName: productName,
          amountOwned: amountOwned,
          productId: productId,
        );
      },
    ),
  );
}

class _ModalContent extends StatefulWidget {
  const _ModalContent({
    required this.context,
    required this.productName,
    required this.amountOwned,
    required this.productId,
  });

  final BuildContext context;
  final String productName;
  final int amountOwned;
  final int productId;

  @override
  State<_ModalContent> createState() => _ModalContentState();
}

class _ModalContentState extends State<_ModalContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late (String, int)? _heroTag;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _heroTag = (widget.productName, widget.productId);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _ = _controller.forward();

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
              tag: _heroTag ?? -1,
              // SingleChildScrollView to avoid the temporary overflow
              // error during the hero animation.
              child: SingleChildScrollView(
                child: CardBase(
                  color: AppColor.ticket,
                  gap: 36,
                  top: CardTitle(
                    title: Text(
                      widget.productName,
                      style: AppTextStyle.ownedTicket,
                    ),
                  ),
                  bottom: FadeTransition(
                    opacity: _animation,
                    child: SlideAction(
                      elevation: 0,
                      text: Strings.useTicket,
                      textStyle: AppTextStyle.buttonText,
                      height: 56,
                      sliderButtonIcon: const Icon(
                        Icons.navigate_next,
                        size: 48,
                      ),
                      sliderButtonIconPadding: 0,
                      innerColor: AppColor.white,
                      outerColor: AppColor.primary,
                      onSubmit: () async {
                        // Disable hero animation in the reverse direction
                        setState(() => _heroTag = null);
                        final ticketCubit = widget.context.read<TicketsCubit>();
                        final receiptCubit =
                            widget.context.read<ReceiptCubit>();
                        await ticketCubit.useTicket(widget.productId);
                        await receiptCubit.fetchReceipts();
                      },
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
  Color get barrierColor => AppColor.scrim;

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
