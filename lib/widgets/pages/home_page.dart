import 'dart:math';

import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/receipt/receipt_cubit.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/cubits/tickets/tickets_cubit.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/repositories/v1/leaderboard_repository.dart';
import 'package:coffeecard/data/repositories/v1/programme_repository.dart';
import 'package:coffeecard/data/repositories/v1/receipt_repository.dart';
import 'package:coffeecard/data/repositories/v1/ticket_repository.dart';
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

  void onBottomNavTap(int index) {
    if (index != _currentPageIndex) {
      setState(() => _currentPageIndex = index);
      return;
    }

    // Reset navigation stack
    {
      final navigatorKey = _pages[index].navigatorKey;
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }

    // Scroll to the top of the page
    {
      final scrollController = _pages[index].scrollController;
      final ms = () {
        final d = max(1, scrollController.position.pixels); // Don't div by zero
        final t = ((1 - 150 / d) * 1500).ceil();
        return max(t, 100);
      }();

      scrollController.animateTo(
        0,
        duration: Duration(milliseconds: ms),
        curve: Curves.easeOutBack,
      );
    }
  }

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
        BlocProvider(
          create: (_) => TicketsCubit(
            sl.get<TicketRepository>(),
          )..getTickets(),
        ),
        BlocProvider(
          create: (_) => ReceiptCubit(
            sl.get<ReceiptRepository>(),
          )..fetchReceipts(),
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
          children: _bottomNavAppFlows,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _pages.map((p) => p.bottomNavigationBarItem).toList(),
          currentIndex: _currentPageIndex,
          onTap: onBottomNavTap,
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

class PageSettings {
  final ScrollController scrollController;
  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavigationBarItem bottomNavigationBarItem;

  PageSettings({
    required this.bottomNavigationBarItem,
  })  : scrollController = ScrollController(),
        navigatorKey = GlobalKey<NavigatorState>();
}

final _pages = <PageSettings>[
  PageSettings(
    bottomNavigationBarItem: const BottomNavigationBarItem(
      icon: Icon(Icons.confirmation_num),
      label: Strings.ticketsNavTitle,
    ),
  ),
  PageSettings(
    bottomNavigationBarItem: const BottomNavigationBarItem(
      icon: Icon(Icons.receipt),
      label: Strings.receiptsNavTitle,
    ),
  ),
  PageSettings(
    bottomNavigationBarItem: const BottomNavigationBarItem(
      icon: Icon(Icons.leaderboard_rounded),
      label: Strings.statsNavTitle,
    ),
  ),
  PageSettings(
    bottomNavigationBarItem: const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: Strings.settingsNavTitle,
    ),
  ),
];

final _bottomNavAppFlows = <AppFlow>[
  AppFlow(
    navigatorKey: _pages[0].navigatorKey,
    initialRoute: TicketsPage.routeWith(
      scrollController: _pages[0].scrollController,
    ),
  ),
  AppFlow(
    navigatorKey: _pages[1].navigatorKey,
    initialRoute: ReceiptsPage.routeWith(
      scrollController: _pages[1].scrollController,
    ),
  ),
  AppFlow(
    navigatorKey: _pages[2].navigatorKey,
    initialRoute: StatsPage.routeWith(
      scrollController: _pages[2].scrollController,
    ),
  ),
  AppFlow(
    navigatorKey: _pages[3].navigatorKey,
    initialRoute: SettingsPage.routeWith(
      scrollController: _pages[3].scrollController,
    ),
  ),
];
