import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:coffeecard/widgets/components/helpers/unordered_list_builder.dart';
import 'package:coffeecard/widgets/pages/entry/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

const terms = [
  'Your email is stored only for identification of users in the app.',
  'Your name may be shown on the leaderboard, both in the app and in Cafe Analog. If you are not comfortable with this, you can choose to be anonymous in the app under Settings.',
  'At any time, you can choose to recall this consent by sending an email to support@analogio.dk.',
];

class RegisterTermsPage extends RegisterPage {
  RegisterTermsPage()
      : super(
          appBarTitle: 'Accept terms',
          title: 'By creating a user, you accept our privacy policy',
          body: _PageBody(),
        );
}

class _PageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const UnorderedListBuilder(
          builder: _explainer,
          texts: terms,
        ),
        const Gap(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                appDialog(
                  context: context,
                  title: 'Privacy policy',
                  children: [
                    const Text(
                      'By creating a user, you accept our privacy policy:',
                    ),
                    const Gap(16),
                    UnorderedListBuilder(
                      builder: (s) => Text(s),
                      texts: terms,
                    ),
                  ],
                  actions: [
                    TextButton(
                      child: const Text('Decline'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Accept'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        // BlocProvider.of<RegisterBloc>(context).add()
                      },
                    ),
                  ],
                );
              },
              child: const Text('Decline'),
            ),
            const Gap(8),
            TextButton(onPressed: () {}, child: const Text('Accept')),
          ],
        )
      ],
    );
  }
}

// TODO: Helper Text classes like this might be useful in the future.
Widget _explainer(String text) => Text(text, style: AppTextStyle.textField);
