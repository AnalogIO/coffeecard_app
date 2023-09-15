import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/app_colors.dart';
import 'package:coffeecard/base/style/app_text_styles.dart';
import 'package:coffeecard/features/environment/presentation/cubit/environment_cubit.dart';
import 'package:coffeecard/widgets/components/loading_overlay.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(48),
      color: AppColors.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error: ${widget.errorMessage}',
            style: AppTextStyle.explainerBright,
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          ElevatedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(AppColors.primary),
              maximumSize: MaterialStateProperty.all(Size.infinite),
              backgroundColor: MaterialStateProperty.all(AppColors.white),
              shape: MaterialStateProperty.all(const StadiumBorder()),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            onPressed: () async {
              final environmentLoaded =
                  context.read<EnvironmentCubit>().getConfig();
              showLoadingOverlay(context);
              // Delay since it is otherwise not obvious
              // a load is happening with no internet
              final _ = await Future.delayed(const Duration(milliseconds: 200));
              await environmentLoaded;
              if (mounted) hideLoadingOverlay(context);
            },
            child: Text(
              Strings.retry,
              style: AppTextStyle.buttonTextDark,
            ),
          ),
        ],
      ),
    );
  }
}
