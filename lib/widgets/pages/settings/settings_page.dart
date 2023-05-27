import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/core/external/external_url_launcher.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/features/contributor/presentation/pages/credits_page.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/api_uri_constants.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:coffeecard/widgets/components/helpers/shimmer_builder.dart';
import 'package:coffeecard/widgets/components/images/analogio_logo.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/settings_group.dart';
import 'package:coffeecard/widgets/components/settings_list_entry.dart';
import 'package:coffeecard/widgets/components/user/user_card.dart';
import 'package:coffeecard/widgets/pages/settings/change_email_page.dart';
import 'package:coffeecard/widgets/pages/settings/change_passcode_flow.dart';
import 'package:coffeecard/widgets/pages/settings/faq_page.dart';
import 'package:coffeecard/widgets/pages/settings/setting_value_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

/// Returns the given callback if the user data has been loaded, otherwise
/// returns null.
void Function()? _tappableIfUserLoaded(
  BuildContext context,
  void Function(BuildContext context, UserLoaded loadedState) callback,
) {
  return switch (context.read<UserCubit>().state) {
    final UserLoaded loadedState => () => callback(context, loadedState),
    _ => null,
  };
}

// This callback is placed outside of any widgets because it is used by
// multiple widgets.
void _creditsTapCallback(BuildContext context) {
  Navigator.push(context, CreditsPage.route).ignore();
}

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
          _ProfileSection(),
          _AccountSection(),
          _AboutSection(),
          _Footer(),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserCubit>().state;
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: switch (userState) {
        UserLoaded(:final user) => UserCard(
            id: user.id,
            name: user.name,
            occupation: user.occupation.fullName,
          ),
        _ => const UserCard.placeholder(),
      },
    );
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection();

  void changeEmailTapCallback(BuildContext context, UserLoaded loadedState) {
    Navigator.push(
      context,
      ChangeEmailPage.routeWith(currentEmail: loadedState.user.email),
    ).ignore();
  }

  void changePasscodeTapCallback(BuildContext context, UserLoaded _) =>
      Navigator.push(context, ChangePasscodeFlow.route);

  void logoutTapCallback(BuildContext context) {
    context.read<AuthenticationCubit>().unauthenticated();
  }

  void deleteAccountTapCallback(BuildContext context, UserLoaded loadedState) {
    _showDeleteAccountDialog(context, loadedState.user.email);
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserCubit>().state;

    return SettingsGroup(
      title: Strings.settingsGroupAccount,
      listItems: [
        SettingListEntry(
          name: Strings.email,
          valueWidget: ShimmerBuilder(
            showShimmer: userState is! UserLoaded,
            builder: (context, colorIfShimmer) {
              return ColoredBox(
                color: colorIfShimmer,
                child: SettingValueText(
                  value: (userState is UserLoaded)
                      ? userState.user.email
                      : Strings.emailShimmerText,
                ),
              );
            },
          ),
          onTap: _tappableIfUserLoaded(context, changeEmailTapCallback),
          // },
        ),
        SettingListEntry(
          name: Strings.passcode,
          valueWidget: const SettingValueText(
            value: Strings.change,
          ),
          onTap: _tappableIfUserLoaded(context, changePasscodeTapCallback),
        ),
        SettingListEntry(
          name: Strings.logOut,
          onTap: () => logoutTapCallback(context),
        ),
        SettingListEntry(
          name: Strings.deleteAccount,
          destructive: true,
          onTap: _tappableIfUserLoaded(context, deleteAccountTapCallback),
        ),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  void faqTapCallback(BuildContext context) {
    Navigator.push(context, FAQPage.route).ignore();
  }

  void privacyPolicyTapCallback(BuildContext context) {
    sl<ExternalUrlLauncher>().launchUrlExternalApplication(
      ApiUriConstants.privacyPolicyUri,
      context,
    );
  }

  void provideFeedbackTapCallback(BuildContext context) {
    sl<ExternalUrlLauncher>().launchUrlExternalApplication(
      ApiUriConstants.feedbackFormUri,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsGroup(
      title: Strings.settingsGroupAbout,
      listItems: [
        SettingListEntry(
          name: Strings.frequentlyAskedQuestions,
          onTap: () => faqTapCallback(context),
        ),
        const SettingListEntry(
          name: Strings.openingHours,
          valueWidget: SettingValueText(
            value: 'Not available',
          ),
        ),
        SettingListEntry(
          name: Strings.privacyPolicy,
          onTap: () => privacyPolicyTapCallback(context),
        ),
        SettingListEntry(
          name: Strings.provideFeedback,
          onTap: () => provideFeedbackTapCallback(context),
        ),
        SettingListEntry(
          name: Strings.credits,
          onTap: () => _creditsTapCallback(context),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final userId = switch (context.watch<UserCubit>().state) {
      UserLoaded(:final user) => user.id.toString(),
      _ => '...',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _creditsTapCallback(context),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                Strings.madeBy,
                style: AppTextStyle.explainer,
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              Text(
                '${Strings.userID}: $userId',
                style: AppTextStyle.explainer,
                textAlign: TextAlign.center,
              ),
              const Gap(24),
              const AnalogIOLogo.small(),
            ],
          ),
        ),
      ),
    );
  }
}

void _showDeleteAccountDialog(BuildContext context, String email) {
  appDialog(
    context: context,
    title: Strings.deleteAccount,
    children: const [Text(Strings.deleteAccountText)],
    actions: <Widget>[
      TextButton(
        child: const Text(
          Strings.buttonUnderstand,
          style: TextStyle(color: AppColor.errorOnBright),
        ),
        onPressed: () {
          context.read<UserCubit>().requestUserAccountDeletion();

          closeAppDialog(context);
          appDialog(
            context: context,
            title: Strings.deleteAccount,
            children: [Text(Strings.deleteAccountEmailConfirmation(email))],
            actions: [
              TextButton(
                child: const Text(Strings.buttonOK),
                onPressed: () {
                  closeAppDialog(context);
                  context.read<AuthenticationCubit>().unauthenticated();
                },
              ),
            ],
            dismissible: false,
          );
        },
      ),
      TextButton(
        onPressed: () => closeAppDialog(context),
        child: const Text(Strings.buttonCancel),
      ),
    ],
    dismissible: true,
  );
}
