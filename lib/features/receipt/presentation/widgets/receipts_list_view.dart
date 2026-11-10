import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/error_section.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/presentation/cubit/receipt_cubit.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/receipt_list_entry_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ReceiptsListView extends StatelessWidget {
  const ReceiptsListView({required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ReceiptCubit, ReceiptState>(
        builder: (context, state) {
          return switch (state.status) {
            ReceiptStatus.initial => const _ReceiptsPlaceholder(),
            ReceiptStatus.success => _ReceiptsLoadedView(scrollController),
            ReceiptStatus.failure => const _ReceiptsErrorView(),
          };
        },
      ),
    );
  }
}

class _ReceiptsErrorView extends StatelessWidget {
  const _ReceiptsErrorView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReceiptCubit>();
    return ErrorSection(
      center: true,
      error: cubit.state.error!,
      retry: cubit.fetchReceipts,
    );
  }
}

class _ReceiptsLoadedView extends StatelessWidget {
  const _ReceiptsLoadedView(this.scrollController);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReceiptCubit>();
    final state = cubit.state;

    return RefreshIndicator(
      displacement: 24,
      onRefresh: cubit.fetchReceipts,
      child: state.filteredReceipts.isEmpty
          ? _ReceiptsEmptyIndicator(
              hasNoReceipts: state.receipts.isEmpty,
              filterCategory: state.filterBy,
            )
          : _GroupedReceipts(
              receipts: state.filteredReceipts,
              scrollController: scrollController,
            ),
    );
  }
}

/// Receipts grouped per day, each day in its own rounded card.
class _GroupedReceipts extends StatelessWidget {
  const _GroupedReceipts({
    required this.receipts,
    required this.scrollController,
  });

  final List<Receipt> receipts;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final days = groupReceiptsByDay(receipts);
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.paddingOf(context).bottom,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final (day, dayReceipts) = days[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Semantics(
                header: true,
                child: Text(
                  receiptDayLabel(day),
                  style: AppTextStyle.ticketLabel,
                ),
              ),
            ),
            DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  children:
                      dayReceipts.map(ReceiptListEntryFactory.create).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Splits [receipts] (newest first) into runs that share a local date.
List<(DateTime, List<Receipt>)> groupReceiptsByDay(List<Receipt> receipts) {
  final days = <(DateTime, List<Receipt>)>[];
  for (final receipt in receipts) {
    final t = receipt.timeUsed.toLocal();
    final day = DateTime(t.year, t.month, t.day);
    if (days.isNotEmpty && days.last.$1 == day) {
      days.last.$2.add(receipt);
    } else {
      days.add((day, [receipt]));
    }
  }
  return days;
}

/// "TODAY", "YESTERDAY" or e.g. "MON 9 NOV".
String receiptDayLabel(DateTime day, {DateTime? now}) {
  final n = now ?? DateTime.now();
  final today = DateTime(n.year, n.month, n.day);
  final diff = today.difference(day).inDays;
  if (diff == 0) return Strings.today.toUpperCase();
  if (diff == 1) return Strings.yesterday.toUpperCase();
  final format = day.year == today.year ? 'EEE d MMM' : 'EEE d MMM y';
  return DateFormat(format).format(day).toUpperCase();
}

class _ReceiptsEmptyIndicator extends StatelessWidget {
  const _ReceiptsEmptyIndicator({
    required this.hasNoReceipts,
    required this.filterCategory,
  });

  /// The user has no receipts of any kind.
  final bool hasNoReceipts;

  final ReceiptFilterCategory filterCategory;

  /// If the user has no receipts of any kind, always show a generic message.
  /// Otherwise, show a message based on `filterCategory`.
  String get _title => hasNoReceipts
      ? Strings.noReceiptsOfTypeTitle(Strings.receipts)
      : Strings.noReceiptsOfTypeTitle(filterCategory.name.toLowerCase());

  String get _buyOrSwipe {
    if (hasNoReceipts) return Strings.buyOrSwipe;
    return filterCategory == ReceiptFilterCategory.swipes
        ? Strings.buy
        : Strings.swipe;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const Gap(48),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            _title,
            textAlign: TextAlign.center,
            style: AppTextStyle.sectionTitle,
            overflow: TextOverflow.visible,
          ),
        ),
        const Gap(8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            Strings.noReceiptsOfTypeMessage(_buyOrSwipe),
            textAlign: TextAlign.center,
            style: AppTextStyle.explainer,
          ),
        ),
      ],
    );
  }
}

class _ReceiptsPlaceholder extends StatelessWidget {
  const _ReceiptsPlaceholder();

  List<Widget> get placeholderListEntries => List.generate(
        20,
        (_) => ReceiptListEntryFactory.create(PlaceholderReceipt()),
      );

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: placeholderListEntries,
    );
  }
}
