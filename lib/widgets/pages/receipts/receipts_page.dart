import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/appbar_with_notification.dart';
import 'package:coffeecard/widgets/components/receipt/filter_bar.dart';
import 'package:coffeecard/widgets/components/receipt/receipt_dropdown.dart';
import 'package:coffeecard/widgets/components/receipt/receipts_list_view.dart';
import 'package:flutter/material.dart';

class ReceiptsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithNotification(
        title: Strings.receiptsPageTitle,
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
