import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/register/register_cubit.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:coffeecard/widgets/components/continue_button.dart';
import 'package:coffeecard/widgets/components/forms/text_field.dart';
import 'package:coffeecard/widgets/components/helpers/unordered_list_builder.dart';
import 'package:coffeecard/widgets/components/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class RegisterNameBody extends StatefulWidget {
  const RegisterNameBody();
  @override
  State<RegisterNameBody> createState() => _RegisterNameBodyState();
}

class _RegisterNameBodyState extends State<RegisterNameBody> {
  final _controller = TextEditingController();
  String get name => _controller.text;

  bool _showError = false;
  String? _error;

  bool _buttonEnabled() => name.isNotEmpty && _error == null;

  Future<void> _validateName(String name) async {
    setState(() => _error = name.isEmpty ? Strings.registerNameEmpty : null);
  }

  Future<void> _submit(BuildContext context) async {
    _showError = true;
    await _validateName(name.trim());
    if (!mounted || _error != null) return;
    //FIXME:
    // ignore: use_build_context_synchronously
    LoadingOverlay.of(context).show();
    // Delay to allow keyboard to disappear before showing dialog
    await Future.delayed(const Duration(milliseconds: 250));
    appDialog(
      context: context,
      title: Strings.registerTermsHeading,
      transparentBarrier: true,
      dismissible: false,
      children: [
        const Text(Strings.registerTermsIntroduction),
        const Gap(16),
        UnorderedListBuilder(
          texts: Strings.registerTerms,
          builder: (s) => Text(s),
        ),
      ],
      actions: [
        TextButton(
          child: const Text(Strings.buttonDecline),
          onPressed: () {
            closeAppDialog(context);
            LoadingOverlay.of(context).hide();
          },
        ),
        TextButton(
          child: const Text(Strings.buttonAccept),
          onPressed: () {
            closeAppDialog(context);
            _register(context.read<RegisterCubit>());
          },
        ),
      ],
    );
  }

  Future<void> _register(RegisterCubit cubit) async {
    cubit.setName(name);
    try {
      await cubit.register();
      await appDialog(
        context: context,
        dismissible: false,
        transparentBarrier: true,
        title: Strings.registerSuccessHeading,
        children: [
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: Strings.registerSuccessBody),
                TextSpan(
                  text: cubit.state.email,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ],
        actions: [
          TextButton(
            onPressed: _closeDialog,
            child: const Text(Strings.buttonOK),
          )
        ],
      );
      if (mounted) LoadingOverlay.of(context).hide();
    } on Exception catch (e) {
      // FIXME wrong error type
      await appDialog(
        context: context,
        dismissible: false,
        transparentBarrier: true,
        title: Strings.registerFailureHeading,
        children: [
          const Text(Strings.registerFailureBody),
          const Gap(12),
          Text(e.toString()),
        ],
        actions: [
          TextButton(
            onPressed: _closeDialog,
            child: const Text(Strings.buttonClose),
          )
        ],
      );
    } finally {
      LoadingOverlay.of(context).hide();
    }
  }

  void _closeDialog() => Navigator.of(context, rootNavigator: true).pop();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          label: Strings.registerNameLabel,
          autofocus: true,
          error: _showError ? _error : null,
          onChanged: () => _validateName(_controller.text),
          onEditingComplete: () => _submit(context),
          controller: _controller,
        ),
        ContinueButton(
          onPressed: () => _submit(context),
          enabled: _buttonEnabled(),
        )
      ],
    );
  }
}
