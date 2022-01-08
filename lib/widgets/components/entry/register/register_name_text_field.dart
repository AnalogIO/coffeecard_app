import 'package:coffeecard/blocs/register/register_bloc.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:coffeecard/widgets/components/forms/text_field.dart';
import 'package:coffeecard/widgets/components/helpers/unordered_list_builder.dart';
import 'package:coffeecard/widgets/components/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class RegisterNameTextField extends StatefulWidget {
  @override
  State<RegisterNameTextField> createState() => _RegisterNameTextFieldState();
}

class _RegisterNameTextFieldState extends State<RegisterNameTextField> {
  final _controller = TextEditingController();

  bool _showError = false;
  String? _error;

  Future<void> _validateName(String name) async {
    setState(() => _error = name.trim().isEmpty ? 'Enter a name' : null);
  }

  Future<void> _submit(BuildContext context) async {
    _showError = true;
    await _validateName(_controller.text);
    if (_error != null) return;
    if (!mounted) return;
    // BlocProvider.of<RegisterBloc>(context).add(AddName(_controller.text));
    LoadingOverlay.of(context).show();
    // Delay to allow keyboard to disappear before showing dialog
    await Future.delayed(const Duration(milliseconds: 250));
    // if (mounted) LoadingOverlay.of(context).hide();
    // await Future.delayed(const Duration(milliseconds: 500));
    appDialog(
      context: context,
      title: 'Privacy policy',
      barrierColor: Colors.transparent,
      children: [
        const Text('By creating a user, you accept our privacy policy:'),
        const Gap(16),
        UnorderedListBuilder(
          texts: terms,
          builder: (s) => Text(s),
        ),
      ],
      actions: [
        TextButton(
          child: const Text('Decline'),
          onPressed: () {
            Navigator.of(context).pop();
            LoadingOverlay.of(context).hide();
          },
        ),
        TextButton(
          child: const Text('Accept'),
          onPressed: () {
            Navigator.of(context).pop();
            LoadingOverlay.of(context).hide();
            // BlocProvider.of<RegisterBloc>(context).add()
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final overlay = LoadingOverlay.of(context);

    return BlocConsumer<RegisterBloc, RegisterState>(
      listenWhen: (previous, current) => previous.loading || current.loading,
      listener: (context, state) {
        state.loading ? overlay.show() : overlay.hide();
      },
      builder: (context, state) {
        return AppTextField(
          label: 'Name',
          hint:
              'Your name may appear on the leaderboards. You can choose to appear anonymous at any time.',
          autofocus: true,
          error: _showError ? _error : null,
          onChanged: () => _validateName(_controller.text),
          onEditingComplete: () => _submit(context),
          controller: _controller,
        );
      },
    );
  }
}

const terms = [
  'Your email is stored only for identification of users in the app.',
  'Your name may be shown on the leaderboard, both in the app and in Cafe Analog. If you are not comfortable with this, you can choose to be anonymous in the app under Settings.',
  'At any time, you can choose to recall this consent by sending an email to support@analogio.dk.',
];
