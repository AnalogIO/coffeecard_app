import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/features/settings/presentation/widgets/sections/about_section.dart';
import 'package:coffeecard/features/settings/presentation/widgets/sections/account_section.dart';
import 'package:coffeecard/features/settings/presentation/widgets/sections/footer.dart';
import 'package:coffeecard/features/settings/presentation/widgets/sections/profile_section.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage._({required this.scrollController});

  static Route routeWith({required ScrollController scrollController}) {
    return MaterialPageRoute(
      builder: (_) => SettingsPage._(scrollController: scrollController),
    );
  }

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.settingsPageTitle,
      body: ListView(
        controller: scrollController,
        children: const [
          ProfileSection(),
          AccountSection(),
          AboutSection(),
          Footer(),
        ],
      ),
    );
  }
}
