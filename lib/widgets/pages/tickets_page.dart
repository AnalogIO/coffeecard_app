import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/widgets/components/analog_closed_popup.dart';
import 'package:coffeecard/widgets/components/appbar_with_notification.dart';
import 'package:coffeecard/widgets/components/shop_section.dart';
import 'package:coffeecard/widgets/components/tickets_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithNotification(
        //FIXME: can we do better?
        displayNotification: context.read<EnvironmentCubit>().state.isTest,
        title: Strings.ticketsPageTitle,
      ),
      body: ListView(
        children: const [
          AnalogClosedPopup(),
          TicketSection(),
          ShopSection(),
        ],
      ),
    );
  }
}
