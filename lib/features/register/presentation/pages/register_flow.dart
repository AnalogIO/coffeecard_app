import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/features/occupation/presentation/cubit/occupation_cubit.dart';
import 'package:coffeecard/features/register/presentation/cubit/register_cubit.dart';
import 'package:coffeecard/features/register/presentation/pages/register_page_email.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/routers/app_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterFlow extends StatelessWidget {
  const RegisterFlow();

  static Route get route =>
      MaterialPageRoute(builder: (_) => const RegisterFlow());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<RegisterCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => sl<OccupationCubit>()..fetchOccupations(),
        ),
      ],
      child: AppScaffold.withTitle(
        title: Strings.registerAppBarTitle,
        body: AppFlow(initialRoute: RegisterPageEmail.route),
      ),
    );
  }
}
