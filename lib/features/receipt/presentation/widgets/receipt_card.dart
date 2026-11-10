import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/helpers/responsive.dart';
import 'package:coffeecard/core/widgets/images/analog_logo.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/time_since.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

final _formatDate = DateFormat('EEE d MMM y · HH:mm').format;

class ReceiptCard extends StatelessWidget {
  final String productName;
  final DateTime time;
  final bool isInOverlay;
  final bool isTestEnvironment;
  final String status;

  const ReceiptCard({
    required this.productName,
    required this.time,
    required this.isInOverlay,
    required this.isTestEnvironment,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final localTime = time.toLocal();
    final paper =
        isTestEnvironment ? AppColors.testEnvironmentReceipt : AppColors.paper;
    final ink = isTestEnvironment ? AppColors.cream : AppColors.roast;
    final muted = isTestEnvironment ? AppColors.cream : AppColors.groundsDark;
    final rule = isTestEnvironment
        ? AppColors.cream.withValues(alpha: .4)
        : const Color(0xffE2D8C6);

    return IgnorePointer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: paper,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
              child: Column(
                children: [
                  if (!isTestEnvironment) AnalogReceiptLogo(),
                  const Gap(16),
                  Text(
                    status.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppTextStyle.ticketLabel.copyWith(
                      color: muted,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Gap(12),
                  Text(
                    productName,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.largeTitle.copyWith(color: ink),
                  ),
                  const Gap(20),
                  _DashedRule(color: rule),
                  const Gap(20),
                  Text(
                    timeSince(localTime),
                    textAlign: TextAlign.center,
                    style: AppTextStyle.ticketFigure.copyWith(
                      fontSize: deviceIsSmall(context) ? 24 : 28,
                      color: ink,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    _formatDate(localTime),
                    textAlign: TextAlign.center,
                    style: AppTextStyle.receiptItemDate.copyWith(
                      fontSize: 13,
                      color: muted,
                    ),
                  ),
                  if (isInOverlay) ...[
                    const Gap(20),
                    _DashedRule(color: rule),
                    const Gap(16),
                    Text(
                      Strings.receiptCardNote,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.ui(13, color: muted),
                    ),
                  ],
                ],
              ),
            ),
          ),
          CustomPaint(
            size: const Size.fromHeight(12),
            painter: _ScallopPainter(paper),
          ),
        ],
      ),
    );
  }
}

class _DashedRule extends StatelessWidget {
  const _DashedRule({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = (constraints.maxWidth / 10).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => SizedBox(
              width: 5,
              height: 2,
              child: ColoredBox(color: color),
            ),
          ),
        );
      },
    );
  }
}

/// The torn edge at the bottom of a printed receipt.
class _ScallopPainter extends CustomPainter {
  const _ScallopPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const step = 16.0;
    final path = Path()..moveTo(0, 0);
    for (var x = 0.0; x < size.width; x += step) {
      final end = (x + step).clamp(0, size.width).toDouble();
      path.quadraticBezierTo((x + end) / 2, size.height * 2, end, 0);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_ScallopPainter oldDelegate) => oldDelegate.color != color;
}
