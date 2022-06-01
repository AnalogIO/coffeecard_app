import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/receipt/filter_bar.dart';
import 'package:coffeecard/widgets/components/receipt/receipt_dropdown.dart';
import 'package:coffeecard/widgets/components/receipt/receipts_list_view.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
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
