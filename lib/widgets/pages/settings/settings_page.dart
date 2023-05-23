//TODO(tta777): Refactor file, so rule does not need to be disabled
//ignore_for_file: prefer-moving-to-variable
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

class SettingsPage extends StatelessWidget {
  const SettingsPage({required this.scrollController});

  static Route routeWith({required ScrollController scrollController}) {
    return MaterialPageRoute(
      builder: (_) => SettingsPage(scrollController: scrollController),
    );
  }

  final ScrollController scrollController;

  /// Tappable only if user data has been loaded.
  void Function()? _ifUserStateLoaded(
    UserState state,
    void Function(UserLoaded) callback,
  ) {
    return (state is! UserLoaded) ? null : () => callback(state);
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserCubit>().state;

    return AppScaffold.withTitle(
      title: Strings.settingsPageTitle,
      body: ListView(
        controller: scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: (userState is UserLoaded)
                ? UserCard(
                    id: userState.user.id,
                    name: userState.user.name,
                    occupation: userState.user.occupation.fullName,
                  )
                : const UserCard.placeholder(),
          ),
          SettingsGroup(
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
                onTap: _ifUserStateLoaded(
                  userState,
                  (st) => Navigator.push(
                    context,
                    ChangeEmailPage.routeWith(currentEmail: st.user.email),
                  ),
                ),
                // },
              ),
              SettingListEntry(
                name: Strings.passcode,
                valueWidget: const SettingValueText(
                  value: Strings.change,
                ),
                onTap: _ifUserStateLoaded(
                  userState,
                  (_) => Navigator.push(context, ChangePasscodeFlow.route),
                ),
              ),
              SettingListEntry(
                name: Strings.logOut,
                onTap: () {
                  context.read<AuthenticationCubit>().unauthenticated();
                },
              ),
              SettingListEntry(
                name: Strings.deleteAccount,
                destructive: true,
                onTap: _ifUserStateLoaded(
                  userState,
                  (st) => _showDeleteAccountDialog(context, st.user.email),
                ),
              ),
            ],
          ),
          SettingsGroup(
            title: Strings.settingsGroupAbout,
            listItems: [
              SettingListEntry(
                name: Strings.frequentlyAskedQuestions,
                onTap: () => Navigator.push(context, FAQPage.route),
              ),
              const SettingListEntry(
                name: Strings.openingHours,
                valueWidget: SettingValueText(
                  value: 'Not available',
                ),
              ),
              SettingListEntry(
                name: Strings.privacyPolicy,
                onTap: () =>
                    sl<ExternalUrlLauncher>().launchUrlExternalApplication(
                  ApiUriConstants.privacyPolicyUri,
                  context,
                ),
              ),
              SettingListEntry(
                name: Strings.provideFeedback,
                onTap: () =>
                    sl<ExternalUrlLauncher>().launchUrlExternalApplication(
                  ApiUriConstants.feedbackFormUri,
                  context,
                ),
              ),
              SettingListEntry(
                name: Strings.credits,
                onTap: () => Navigator.push(context, CreditsPage.route),
              ),
            ],
          ),
          const Gap(24),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.push(context, CreditsPage.route),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    Strings.madeBy,
                    style: AppTextStyle.explainer,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(8),
                  Text(
                    '${Strings.userID}: ${userState is UserLoaded ? userState.user.id : '...'}',
                    style: AppTextStyle.explainer,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(24),
                  const AnalogIOLogo.small(),
                ],
              ),
            ),
          ),
          const Gap(24),
        ],
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
