import 'package:coffeecard/blocs/entry/entry_router_cubit.dart';
import 'package:coffeecard/widgets/pages/entry/register_page.dart';
import 'package:coffeecard/widgets/routers/login_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EntryRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EntryRouterCubit(),
      child: BlocBuilder<EntryRouterCubit, EntryRoute>(
        builder: (context, route) {
          return route == EntryRoute.login ? LoginRouter() : RegisterPage();
        },
      ),
    );
  }
}

// class EntryRouter extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => EntryRouterCubit(),
//       child: BlocListener<EntryRouterCubit, EntryRoute>(
//         listener: (context, route) {
//           if (route == EntryRoute.login) {
//             return LoginRouter();
//           } else {
//             return RegisterPage();
//           }
//         },
//         child: LoginRouter(),
//       ),
//     );
//   }
// }
