import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/widgets/components/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashErrorPage extends StatefulWidget {
  const SplashErrorPage();

  @override
  State<SplashErrorPage> createState() => _SplashErrorPageState();
}

class _SplashErrorPageState extends State<SplashErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            Strings.noInternet,
            style: AppTextStyle.explainerBright,
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(AppColor.primary),
              maximumSize: MaterialStateProperty.all(Size.infinite),
              backgroundColor: MaterialStateProperty.all(AppColor.white),
              shape: MaterialStateProperty.all(const StadiumBorder()),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            onPressed: () async {
              final environmentLoaded =
                  context.read<EnvironmentCubit>().getConfig();
              LoadingOverlay.of(context).show();
              // Delay since it is otherwise not obvious
              // a load is happening with no internet
              await Future.delayed(const Duration(milliseconds: 200));
              await environmentLoaded;
              if (mounted) LoadingOverlay.of(context).hide();
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