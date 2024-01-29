import 'dart:math';

import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/helpers/lazy_indexed_stack.dart';
import 'package:coffeecard/core/widgets/routers/app_flow.dart';
import 'package:coffeecard/features/leaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:coffeecard/features/leaderboard/presentation/pages/leaderboard_page.dart';
import 'package:coffeecard/features/opening_hours/presentation/cubit/opening_hours_cubit.dart';
import 'package:coffeecard/features/product/product.dart';
import 'package:coffeecard/features/receipt/presentation/cubit/receipt_cubit.dart';
import 'package:coffeecard/features/receipt/presentation/pages/receipts_page.dart';
import 'package:coffeecard/features/settings/presentation/pages/settings_page.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:coffeecard/features/ticket/presentation/pages/tickets_page.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage._({required this.products});
  final PurchasableProducts products;

  static Route routeWith({required PurchasableProducts products}) {
    return MaterialPageRoute(builder: (_) => HomePage._(products: products));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  List<int> _navFlowsStack = [0];

  void onNavFlowChange(int newFlowIndex) {
    setState(() => _currentPageIndex = newFlowIndex);

    if (newFlowIndex == 0) {
      _navFlowsStack = [0];
      return;
    }
    _navFlowsStack
      ..remove(newFlowIndex)
      ..add(newFlowIndex);
  }

  Future<bool> onWillPop() async {
    // If back arrow is present on page, go back in the current flow
    {
      final currentFlow = _navFlowsStack.last;
      final currentNavigator = _pages[currentFlow].navigatorKey.currentState!;
      if (currentNavigator.canPop()) {
        return true;
      }
    }

    if (_navFlowsStack.removeLast() == 0) {
      return true;
    }
    setState(() => _currentPageIndex = _navFlowsStack.last);
    return false;
  }

  void onBottomNavTap(int index) {
    if (index != _currentPageIndex) {
      onNavFlowChange(index);
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
        // We divide by d in the next line, so make sure it cannot be zero
        final d = max(1, scrollController.position.pixels);
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

  final _bottomNavAppFlows = <AppFlow>[
    AppFlow(
      navigatorKey: _pages.first.navigatorKey,
      initialRoute: TicketsPage.routeWith(
        scrollController: _pages.first.scrollController,
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
      initialRoute: StatisticsPage.routeWith(
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

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (BuildContext context) => widget.products,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<TicketsCubit>()..getTickets(),
          ),
          BlocProvider(
            create: (_) => sl<ReceiptCubit>()..fetchReceipts(),
          ),
          BlocProvider(
            create: (_) => sl<LeaderboardCubit>()..loadLeaderboard(),
          ),
          BlocProvider(
            create: (_) => sl<OpeningHoursCubit>()..getOpeninghours(),
          ),
        ],
        child: PopScope(
          onPopInvoked: (_) => onWillPop(),
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: LazyIndexedStack(
              index: _currentPageIndex,
              children: _bottomNavAppFlows,
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: _pages.map((p) => p.bottomNavigationBarItem).toList(),
              currentIndex: _currentPageIndex,
              onTap: onBottomNavTap,
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.primary,
              selectedItemColor: AppColors.white,
              unselectedItemColor: AppColors.white.withOpacity(0.5),
              selectedFontSize: 12,
              unselectedLabelStyle: AppTextStyle.bottomNavBarLabel,
              selectedLabelStyle: AppTextStyle.bottomNavBarLabel,
            ),
          ),
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
