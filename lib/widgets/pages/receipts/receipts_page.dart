import 'package:coffeecard/widgets/components/app_bar_title.dart';
import 'package:coffeecard/widgets/components/dropdowns/receipt_dropdown.dart';
import 'package:coffeecard/widgets/components/receipt/filter_bar.dart';
import 'package:coffeecard/widgets/components/receipt/receipts_list_view.dart';
import 'package:flutter/material.dart';

class ReceiptsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle('Receipts'),
      ),
      body: Column(
        children: [
          FilterBar(
            title: 'Show',
            dropdown: ReceiptDropdown(),
          ),
          ReceiptsListView(),
        ],
      ),
    );
  }
}
