import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/loading_overlay.dart';
import 'package:coffeecard/core/widgets/components/rounded_button.dart';
import 'package:coffeecard/features/environment/presentation/cubit/environment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SplashErrorPage extends StatefulWidget {
  const SplashErrorPage({required this.errorMessage});
  final String errorMessage;

  @override
  State<SplashErrorPage> createState() => _SplashErrorPageState();
}

class _SplashErrorPageState extends State<SplashErrorPage> {
  Future<void> onTap() async {
    LoadingOverlay.show(context).ignore();

    // Show loading overlay for at least 200 ms, otherwise it
    // may not be obvious that a load is happening with no internet
    await Future.wait<void>([
      Future.delayed(const Duration(milliseconds: 200)),
      context.read<EnvironmentCubit>().getConfig(),
    ]);

    if (mounted) {
      LoadingOverlay.hide(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error: ${widget.errorMessage}',
            style: AppTextStyle.explainerBright,
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          RoundedButton.bright(text: Strings.retry, onTap: onTap),
        ],
      ),
    );
  }
}
