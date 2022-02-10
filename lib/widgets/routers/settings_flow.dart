import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/settings/settings_cubit.dart';
import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/pages/settings/settings_page.dart';
import 'package:coffeecard/widgets/pages/settings/your_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsFlow extends StatelessWidget {
  static Route get route => MaterialPageRoute(builder: (_) => SettingsFlow());

  static const settingsRoute = '/';
  static const yourProfileRoute = '/your-profile';

  static final navigatorKey = GlobalKey<NavigatorState>();
  static void push(String route) => navigatorKey.currentState!.pushNamed(route);

  Future<bool> _didPopRoute() async => navigatorKey.currentState!.maybePop();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await _didPopRoute(),
      child: BlocProvider(
        create: (_) {
          final repo = sl.get<AccountRepository>();
          return SettingsCubit(repo)..loadUser();
        },
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
      case settingsRoute:
        return _route(const SettingsPage());
      case yourProfileRoute:
        return _route(const YourProfilePage());
      default:
        throw Exception(Strings.invalidRoute('SettingsFlow', settings.name));
    }
  }
}
