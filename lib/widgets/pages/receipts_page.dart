import 'package:coffeecard/blocs/receipt/receipt_bloc.dart';
import 'package:coffeecard/data/repositories/receipt_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/receipt/drop_down_menu.dart';
import 'package:coffeecard/widgets/components/receipt/receipt_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceiptsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReceiptBloc(repository: sl.get<ReceiptRepository>())
        ..add(ReloadReceipts()),
      child: BlocBuilder<ReceiptBloc, ReceiptState>(
        builder: (context, state) {
          if (state is ReceiptLoaded) {
            return Column(
              children: [
                DropDownMenu(),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: state.receiptsForDisplay.length,
                    itemBuilder: (context, index) {
                      return ReceiptListEntry(
                        receipt: state.receiptsForDisplay[index],
                      );
                    },
                  ),
                )
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
