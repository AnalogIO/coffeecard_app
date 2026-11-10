import 'package:animations/animations.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/helpers/shimmer_builder.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/presentation/pages/view_receipt_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _formatDateTime = DateFormat('d MMM · HH:mm').format;

class ReceiptListEntry extends StatelessWidget {
  final bool tappable;
  final String productName;
  final String menuItemName;
  final DateTime time;
  final bool isPurchase;
  final bool showShimmer;
  final String topText;
  final String rightText;
  final Color backgroundColor;
  final String status;

  const ReceiptListEntry({
    required this.tappable,
    required this.productName,
    required this.menuItemName,
    required this.time,
    required this.isPurchase,
    required this.showShimmer,
    required this.topText,
    required this.rightText,
    required this.backgroundColor,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final time = this.time.toLocal();
    // Purchases that did not complete get a neutral icon.
    final muted =
        isPurchase && backgroundColor != AppColors.slightlyHighlighted;

    return OpenContainer(
      tappable: tappable,
      closedElevation: 0,
      openElevation: 0,
      closedColor: backgroundColor,
      openColor: AppColors.background,
      // Remove rounded edges
      closedShape: const RoundedRectangleBorder(),
      openBuilder: (context, _) {
        return ViewReceiptPage(
          receipt: SwipeReceipt(
            productName: productName,
            timeUsed: time,
            id: 0,
            menuItemName: menuItemName,
          ),
        );
      },
      closedBuilder: (context, openContainer) {
        return ShimmerBuilder(
          showShimmer: showShimmer,
          builder: (context, colorIfShimmer) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: backgroundColor,
                border: const Border(
                  bottom: BorderSide(color: AppColors.divider),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    _ReceiptIcon(
                      isPurchase: isPurchase,
                      muted: muted,
                      shimmerColor: showShimmer ? colorIfShimmer : null,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ColoredBox(
                            color: colorIfShimmer,
                            child: Text(
                              topText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.ui(15, weight: 600),
                            ),
                          ),
                          const SizedBox(height: 2),
                          ColoredBox(
                            color: colorIfShimmer,
                            child: Text(
                              status,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.ui(
                                12,
                                color: AppColors.grounds,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ColoredBox(
                          color: colorIfShimmer,
                          child: Text(
                            rightText,
                            style: AppTextStyle.receiptItemDate.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.roast,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        ColoredBox(
                          color: colorIfShimmer,
                          child: Text(
                            _formatDateTime(time),
                            style: AppTextStyle.receiptItemDate.copyWith(
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ReceiptIcon extends StatelessWidget {
  const _ReceiptIcon({
    required this.isPurchase,
    required this.muted,
    this.shimmerColor,
  });

  final bool isPurchase;
  final bool muted;
  final Color? shimmerColor;

  @override
  Widget build(BuildContext context) {
    final background = shimmerColor ??
        switch ((isPurchase, muted)) {
          (true, true) => AppColors.border,
          (true, false) => AppColors.caramel,
          (false, _) => AppColors.espresso,
        };
    final foreground = isPurchase ? AppColors.espresso : AppColors.cream;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: shimmerColor != null
          ? null
          : Icon(
              isPurchase ? Icons.add_rounded : Icons.local_cafe_outlined,
              size: 18,
              color: foreground,
            ),
    );
  }
}
