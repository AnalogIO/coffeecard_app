import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/receipt/receipt_cubit.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/repositories/v1/leaderboard_repository.dart';
import 'package:coffeecard/data/repositories/v1/programme_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/helpers/lazy_indexed_stack.dart';
import 'package:coffeecard/widgets/pages/receipts/receipts_page.dart';
import 'package:coffeecard/widgets/pages/settings/settings_page.dart';
import 'package:coffeecard/widgets/pages/stats_page.dart';
import 'package:coffeecard/widgets/pages/tickets/tickets_page.dart';
import 'package:coffeecard/widgets/routers/app_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  static Route get route => MaterialPageRoute(builder: (_) => HomePage());

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserCubit(
            sl.get<AccountRepository>(),
            sl.get<ProgrammeRepository>(),
          )..fetchUserDetails(),
        ),
        BlocProvider.value(
          value: sl.get<ReceiptCubit>()..fetchReceipts(),
        ),
        BlocProvider(
          create: (_) => StatisticsCubit(
            sl.get<LeaderboardRepository>(),
          )..fetchLeaderboards(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColor.background,
        body: LazyIndexedStack(
          index: _currentPageIndex,
          children: [
            AppFlow(initialRoute: TicketsPage.route),
            AppFlow(initialRoute: ReceiptsPage.route),
            AppFlow(initialRoute: StatsPage.route),
            AppFlow(initialRoute: SettingsPage.route),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _bottomNavBarItems,
          currentIndex: _currentPageIndex,
          onTap: (index) => setState(() => _currentPageIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColor.primary,
          selectedItemColor: AppColor.white,
          unselectedItemColor: AppColor.white.withOpacity(0.5),
          selectedFontSize: 12,
          unselectedLabelStyle: AppTextStyle.medium,
          selectedLabelStyle: AppTextStyle.medium,
        ),
      ),
    );
  }
}

const _bottomNavBarItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.style),
    label: Strings.ticketsNavTitle,
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.receipt),
    label: Strings.receiptsNavTitle,
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.trending_up),
    label: Strings.statsNavTitle,
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.settings),
    label: Strings.settingsNavTitle,
  ),
];
