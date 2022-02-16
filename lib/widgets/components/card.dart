import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

abstract class CardBase extends StatelessWidget {
  /// Base widget for a card that matches the
  /// specification of the Analog app redesign.
  ///
  /// Exactly one of the [top] or [title] arguments must not be null.
  /// If [title] is null, [description] must also be null.
  ///
  /// If [onTap] is not null, the card will show a
  /// splash effect when tapped.
  const CardBase({
    Key? key,
    required this.top,
    this.bottom = const SizedBox.shrink(),
    this.gap = 0,
    required this.color,
    this.borderColor,
    this.dense = false,
    this.disabled = false,
    this.onTap,
  }) : super(key: key);

  /// Widget to be placed at the top of the card.
  final Widget top;

  /// Widget to be placed at the bottom of the card.
  ///
  /// If a row is needed, use a [CardBottomRow].
  final Widget bottom;

  /// Amount of space between the bottom widgets
  /// and the title/description or top widget.
  final double gap;

  /// Background color of the card.
  final Color color;

  /// Color of the border of the card. If null, no border is shown.
  final Color? borderColor;

  /// Decreases the amount of padding of the card.
  final bool dense;

  /// Greys out the card.
  final bool disabled;

  /// If not null, the card will splash when tapped.
  final VoidCallback? onTap;

  Widget get _cardContent {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [top, Gap(gap), bottom],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tappable(
      elevation: 1,
      padding: EdgeInsets.all(dense ? 16 : 24),
      color: color,
      borderRadius: BorderRadius.circular(24),
      borderColor: borderColor,
      onTap: onTap,
      child: _cardContent,
    );
  }
}

/// Wraps the card in a IgnorePointer class, deferring pointer events
/// to the widget underneath the card.
///
/// Used for [ReceiptCard].
mixin IgnorePointerCard on CardBase {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(child: super.build(context));
  }
}

/// Helper widget to include a title and an (optional)
/// description at the top of a card.
class CardTitle extends StatelessWidget {
  final Text title;
  final Text? description;
  const CardTitle({
    Key? key,
    required this.title,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        if (description != null) description!,
      ],
    );
  }
}

/// Provides proper alignment and positioning for multiple
/// widget to be placed at the bottom of a card.
class CardBottomRow extends StatelessWidget {
  const CardBottomRow({
    Key? key,
    this.gap = 0,
    this.left = const SizedBox.shrink(),
    this.right = const SizedBox.shrink(),
  }) : super(key: key);

  /// The minimum space between the left and right widget.
  final double gap;

  /// The widget shown to the left.
  /// Will expand/wrap to ensure the right widget will be shown fully.
  final Widget left;

  /// The widget shown to the right.
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Padding(padding: EdgeInsets.only(right: gap), child: left),
        ),
        right,
      ],
    );
  }
}
