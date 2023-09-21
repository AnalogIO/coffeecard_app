import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/presentation/cubit/receipt_cubit.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/receipt_list_entry_factory.dart';
import 'package:coffeecard/widgets/components/error_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

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
          : ListView.builder(
              controller: scrollController,
              itemCount: state.filteredReceipts.length,
              itemBuilder: (_, index) {
                final receipt = state.filteredReceipts[index];
                return ReceiptListEntryFactory.create(receipt);
              },
            ),
    );
  }
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
