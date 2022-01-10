import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/blocs/receipt/receipt_bloc.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/data/repositories/receipt_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
                    return ReceiptEntry(
                      receipt: state.receiptsForDisplay[index],
                    );
                  },
                ))
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

class ListEntry extends StatelessWidget {
  final Widget leftWidget;
  final Widget rightWidget;
  final void Function()? onTap;
  final Color? backgroundColor;

  const ListEntry(
      {required this.leftWidget,
      required this.rightWidget,
      this.onTap,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final childWidget = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColor.white,
        border: const Border(bottom: BorderSide(color: AppColor.lightGray)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leftWidget,
            rightWidget,
          ],
        ),
      ),
    );

    if (onTap == null) {
      return childWidget;
    } else {
      return Tappable(
        onTap: onTap!,
        child: childWidget,
      );
    }
  }
}

class DropDownMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptBloc, ReceiptState>(
      builder: (context, state) {
        return Container(
          color: AppColor.secondary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.all(16),
                  child: Text('Show', style: AppTextStyle.buttonText)),
              Container(
                height: 32,
                width: 190,
                padding: const EdgeInsets.only(left: 25),
                decoration: const ShapeDecoration(
                  color: AppColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<DropDownOptions>(
                    value: state.index,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: AppColor.slightlyHighlighted,
                    ),
                    dropdownColor: AppColor.primary,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(15),
                    //TODO, do we want the border radius?
                    style: AppTextStyle.buttonText,
                    onChanged: (option) {
                      final ReceiptEvent event;
                      switch (option!) {
                        case DropDownOptions.swipesAndPurchases:
                          event = DisplayAll();
                          break;
                        case DropDownOptions.swipes:
                          event = DisplayUsedTicket();
                          break;
                        case DropDownOptions.purchases:
                          event = DisplayPurchases();
                          break;
                      }
                      context.read<ReceiptBloc>().add(event);
                    },
                    items: state.dropDownOptions
                        .entries //Creates the drop down items based on the map in the receiptBlock
                        .map<DropdownMenuItem<DropDownOptions>>((entry) {
                      return DropdownMenuItem<DropDownOptions>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const Spacer(),
              Tappable(
                  padding: const EdgeInsets.only(right: 16),
                  onTap: () {
                    context.read<ReceiptBloc>().add(ReloadReceipts());
                  },
                  child: const Icon(
                    Icons.refresh,
                    color: AppColor.slightlyHighlighted,
                  ))
            ],
          ),
        );
      },
    );
  }
}

class ReceiptEntry extends StatelessWidget {
  final Receipt receipt;

  DateFormat get formatter => DateFormat(
      'dd/MM-yyyy'); //TODO consider if it can be stored centrally, so each entry does not end up with a copy of the formatter

  const ReceiptEntry({
    required this.receipt,
  });

  @override
  Widget build(BuildContext context) {
    return ListEntry(
      leftWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            receipt.transactionType == TransactionType.purchase
                ? 'Bought ${receipt.amountPurchased} ${receipt.productName}'
                : 'Used ${receipt.productName}',
            style: AppTextStyle.recieptItemKey,
          ),
          Text(formatter.format(receipt.timeUsed),
              style: AppTextStyle.recieptItemDate)
        ],
      ),
      rightWidget: Text(
        receipt.transactionType == TransactionType.purchase
            ? '${receipt.price},-'
            : '${receipt.price} ticket',
        style: AppTextStyle.recieptItemValue,
      ),
      onTap: () {
        print(receipt);
      },
      backgroundColor: receipt.transactionType == TransactionType.purchase
          ? AppColor.slightlyHighlighted
          : AppColor.white,
    );
  }
}
