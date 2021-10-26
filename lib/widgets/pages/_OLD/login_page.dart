// import 'package:coffeecard/base/style/colors.dart';
// import 'package:coffeecard/blocs/login/login_bloc.dart';
// import 'package:coffeecard/persistence/repositories/authentication_service.dart';
// import 'package:coffeecard/widgets/analog_logo.dart';
// import 'package:coffeecard/widgets/components/loading_overlay.dart';
// import 'package:coffeecard/widgets/components/login/login_cta.dart';
// import 'package:coffeecard/widgets/components/login/login_input_hint.dart';
// import 'package:coffeecard/widgets/components/login/login_input_password.dart';
// import 'package:coffeecard/widgets/components/login/login_numpad.dart';
// import 'package:coffeecard/widgets/components/login/login_text_field.dart';
// import 'package:coffeecard/widgets/components/login/login_title.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../service_locator.dart';

// class LoginPage extends StatelessWidget {
//   static Route route() {
//     return MaterialPageRoute<void>(builder: (_) => LoginPage());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final overlay = LoadingOverlay.of(context);
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: AppColor.primary,
//       body: Center(
//         child: BlocProvider(
//           create: (context) {
//             return LoginBloc(
//               authenticationService: sl.get<AuthenticationService>(),
//             );
//           },
//           child: BlocListener<LoginBloc, LoginState>(
//             listenWhen: (previous, current) =>
//                 previous is LoginStateLoading || current is LoginStateLoading,
//             listener: (context, state) =>
//                 (state is LoginStateLoading) ? overlay.show() : overlay.hide(),
//             child: Column(
//               children: <Widget>[LoginUpper(), Numpad()],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class LoginUpper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LoginBloc, LoginState>(
//       buildWhen: (previous, current) => false,
//       builder: (context, state) {
//         return Expanded(
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             color: AppColor.primary,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 AnalogLogo(),
//                 Container(height: 16),
//                 const LoginTitle("SampleText"),
//                 Container(height: 16),
//                 Visibility(
//                   visible: false,
//                   replacement: LoginInputPassword(),
//                   child: LoginTextField(),
//                 ),
//                 LoginInputHint(),
//                 LoginCTA()
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
