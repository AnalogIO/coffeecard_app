import 'package:flutter/material.dart';

import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';

import 'package:coffeecard/widgets/pages/tickets_page.dart';
import 'package:coffeecard/widgets/pages/receipts_page.dart';
import 'package:coffeecard/widgets/pages/stats_page.dart';
import 'package:coffeecard/widgets/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  static Route get route => MaterialPageRoute<void>(builder: (_) => HomePage());

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;

  final List<Page> _pages = [
    Page(Strings.ticketsPageTitle, Strings.ticketsNavTitle, Icons.style,
        TicketsPage()),
    Page(Strings.receiptsPageTitle, Strings.receiptsNavTitle, Icons.receipt,
        ReceiptsPage()),
    Page(Strings.statsPageTitle, Strings.statsNavTitle, Icons.trending_up,
        StatsPage()),
    Page(Strings.settingsPageTitle, Strings.settingsNavTitle, Icons.settings,
        SettingsPage()),
  ];

  Page get _currentPage => _pages[_currentPageIndex];

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          title: Text(_currentPage.appBarTitle, style: AppTextStyle.pageTitle),
        ),
        body: _currentPage.body,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPageIndex,
          onTap: _onBottomNavTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColor.primary,
          selectedItemColor: AppColor.white,
          unselectedItemColor: AppColor.white.withOpacity(0.5),
          selectedFontSize: 12,
          items: List.generate(
              _pages.length,
              (index) => BottomNavigationBarItem(
                  icon: Icon(_pages[index].icon),
                  title: Text(_pages[index].navBarTitle,
                      style: AppTextStyle.medium))),
        ));
  }
}

class Page {
  final String appBarTitle;
  final String navBarTitle;
  final IconData icon;
  final Widget body;

  const Page(
    this.appBarTitle,
    this.navBarTitle,
    this.icon,
    this.body,
  );
}
