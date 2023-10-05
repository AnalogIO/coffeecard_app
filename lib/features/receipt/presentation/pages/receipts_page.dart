import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/filter_bar.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/receipt_dropdown.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/receipts_list_view.dart';
import 'package:flutter/material.dart';

class ReceiptsPage extends StatelessWidget {
  const ReceiptsPage({required this.scrollController});

  final ScrollController scrollController;

  static Route routeWith({required ScrollController scrollController}) {
    return MaterialPageRoute(
      builder: (_) => ReceiptsPage(scrollController: scrollController),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.receiptsPageTitle,
      body: Column(
        children: [
          FilterBar(
            title: 'Show',
            dropdown: ReceiptDropdown(),
          ),
          ReceiptsListView(scrollController: scrollController),
        ],
      ),
    );
  }
}
