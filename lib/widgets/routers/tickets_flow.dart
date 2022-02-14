import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/tickets_page/tickets_cubit.dart';
import 'package:coffeecard/widgets/pages/tickets/buy_tickets_page.dart';
import 'package:coffeecard/widgets/pages/tickets/redeem_voucher_page.dart';
import 'package:coffeecard/widgets/pages/tickets/tickets_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketsFlow extends StatelessWidget {
  const TicketsFlow();

  static Route get route =>
      MaterialPageRoute(builder: (_) => const TicketsFlow());

  static const ticketsRoute = '/';
  static const buyTicketsRoute = '/buy-tickets';
  static const redeemVoucherRoute = '/redeem-voucher';

  static final navigatorKey = GlobalKey<NavigatorState>();
  static void push(String route) => navigatorKey.currentState!.pushNamed(route);

  Future<bool> _didPopRoute() async => navigatorKey.currentState!.maybePop();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await _didPopRoute(),
      child: BlocProvider(
        create: (_) => TicketsCubit()..getTickets(),
        child: Navigator(
          key: navigatorKey,
          onGenerateRoute: _onGenerateRoute,
        ),
      ),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    Route _route(Widget page) => MaterialPageRoute(builder: (_) => page);

    switch (settings.name) {
      case ticketsRoute:
        return _route(const TicketsPage());
      case buyTicketsRoute:
        return _route(const BuyTicketsPage());
      case redeemVoucherRoute:
        return _route(const RedeemVoucherPage());
      default:
        throw Exception(
          Strings.invalidRoute(runtimeType.toString(), settings.name),
        );
    }
  }
}
