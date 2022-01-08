// import 'package:coffeecard/widgets/text_field.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:flutter/material.dart';

class ReceiptsPage extends StatelessWidget {
  var items = [
    "itesm 1",
    "itesm 2",
    "itesm 3",
    "itesm 4",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ReceiptEntry(header: items[index], date: items[index], price: items[index]);
      },
    );
  }
}

class ListEntry extends StatelessWidget {
  final Widget leftWidget;
  final Widget rightWidget;
  final bool isTapAble;
  final void Function() onTap;

  const ListEntry({required this.leftWidget, required this.rightWidget, required this.isTapAble, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tappable(
      color: AppColor.white,
      border: const Border(bottom: BorderSide(color: AppColor.lightGray)),
      onTap: onTap,
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
  }
}

class ReceiptEntry extends StatelessWidget {
  final String header;
  final String date;
  final String price;

  const ReceiptEntry({
    required this.header,
    required this.date,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return ListEntry(
      leftWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: AppTextStyle.recieptItemKey,
          ),
          Text(date, style: AppTextStyle.recieptItemDate)
        ],
      ),
      rightWidget: Text(
        price,
        style: AppTextStyle.recieptItemValue,
      ),
      isTapAble: true,
      onTap: () {},
    );
  }
}
