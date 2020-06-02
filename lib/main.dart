import 'package:flutter/material.dart';

import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';

import 'package:coffeecard/widgets/pages/tickets_page.dart';
import 'package:coffeecard/widgets/pages/receipts_page.dart';
import 'package:coffeecard/widgets/pages/stats_page.dart';
import 'package:coffeecard/widgets/pages/settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Café Analog',
      theme: ThemeData(
        primarySwatch: AppColor.createMaterialColor(AppColor.primary),
        primaryColor: AppColor.primary,
        brightness: Brightness.dark,
        backgroundColor: AppColor.background,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;

  List pages = [
    {
      'title': 'Tickets',
      'icon': Icons.style,
      'page': TicketsPage()
    },
    {
      'title': 'Receipts',
      'icon': Icons.receipt,
      'page': ReceiptsPage()
    },
    {
      'title': 'Stats',
      'icon': Icons.trending_up,
      'page': StatsPage()
    },
    {
      'title': 'Settings',
      'icon': Icons.settings,
      'page': SettingsPage()
    },
  ];

  get _currentPage => pages[_currentPageIndex];

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
        title: Text(
          _currentPage['title'],
          style: AppTextStyle.pageTitle
        ),
      ),
      body: _currentPage['page'],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: _onBottomNavTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColor.primary,
        selectedItemColor: AppColor.white,
        unselectedItemColor: AppColor.white.withOpacity(0.5),
        selectedFontSize: 12,
        items: List.generate(pages.length, (index) => BottomNavigationBarItem(
            icon: Icon(pages[index]['icon']),
            title: Text(pages[index]['title'], style: AppTextStyle.medium)
          )
        ),
      )
    );
  }
}
