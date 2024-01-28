part of 'tickets_card.dart';

/// A widget that shows instead of a [TicketsCard] when the user has no tickets.
class NoTicketsPlaceholder extends StatelessWidget {
  const NoTicketsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: AppColors.secondary,
      strokeWidth: 2,
      borderType: BorderType.RRect,
      radius: const Radius.circular(24),
      padding: const EdgeInsets.symmetric(vertical: 60),
      dashPattern: const [8, 4],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Strings.emptyCoffeeCardTextTop,
              style: AppTextStyle.explainer,
            ),
            Text(
              Strings.emptyCoffeeCardTextBottom,
              style: AppTextStyle.explainer,
            ),
          ],
        ),
      ),
    );
  }
}
