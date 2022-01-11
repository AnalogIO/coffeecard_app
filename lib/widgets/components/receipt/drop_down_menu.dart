import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/blocs/receipt/receipt_bloc.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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