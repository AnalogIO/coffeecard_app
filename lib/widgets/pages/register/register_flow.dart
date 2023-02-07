import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/occupation/occupation_cubit.dart';
import 'package:coffeecard/cubits/register/register_cubit.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/repositories/v1/occupation_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/pages/register/register_page_email.dart';
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
          create: (_) => RegisterCubit(repository: sl<AccountRepository>()),
        ),
        BlocProvider(
          lazy: false,
          create: (_) =>
              OccupationCubit(occupationRepository: sl<OccupationRepository>())
                ..getOccupations(),
        ),
      ],
      child: AppScaffold.withTitle(
        title: Strings.registerAppBarTitle,
        body: AppFlow(initialRoute: RegisterPageEmail.route),
      ),
    );
  }
}
