// import 'package:coffeecard/base/style/colors.dart';
// import 'package:coffeecard/blocs/login/login_bloc.dart';
// import 'package:coffeecard/widgets/analog_logo.dart';
// import 'package:coffeecard/widgets/components/login/login_cta.dart';
// import 'package:coffeecard/widgets/components/login/login_input_hint.dart';
// import 'package:coffeecard/widgets/components/login/login_numpad.dart';
// import 'package:coffeecard/widgets/components/entry/login/login_text_field.dart';
// import 'package:coffeecard/widgets/components/login/login_title.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class LoginPage2 extends StatelessWidget {
//   final String title = 'Sign in';

//   static Route route() {
//     return MaterialPageRoute<void>(builder: (_) => LoginPage2());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => LoginBloc(),
//       child: BlocBuilder<LoginBloc, LoginState>(
//         buildWhen: (previous, current) => previous.hasError || current.hasError,
//         builder: (context, state) {
//           return Scaffold(
//             backgroundColor: AppColor.primary,
//             body: SafeArea(
//               minimum: const EdgeInsets.all(16),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     AnalogLogo(),
//                     Padding(
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       child: LoginTitle(title),
//                     ),
//                     LoginTextField(error: state.error),
//                     LoginInputHint(error: state.error),
//                     LoginCTA(
//                       text: "Don't have an account? Make one",
//                       onPressed: () {},
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//   // Widget build(BuildContext context) {
//   //   final overlay = LoadingOverlay.of(context);
//   //   return Scaffold(
//   //     // resizeToAvoidBottomInset: false,
//   //     backgroundColor: AppColor.primary,
//   //     body: SafeArea(
//   //       child: BlocProvider(
//   //         create: (context) {
//   //           return LoginBloc(
//   //               authenticationService: sl.get<AuthenticationService>());
//   //         },
//   //         child: BlocListener<LoginBloc, LoginState>(
//   //           listenWhen: (previous, current) =>
//   //               previous is LoginStateLoading || current is LoginStateLoading,
//   //           listener: (context, state) =>
//   //               (state is LoginStateLoading) ? overlay.show() : overlay.hide(),
//   //           child: Column(
//   //             children: <Widget>[
//   //               AnalogLogo(),
//   //             ],
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
// }

// // class LoginUpper2 extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocBuilder<LoginBloc, LoginState>(
// //       buildWhen: (previous, current) => previous.onPage != current.onPage,
// //       builder: (context, state) {
// //         return Expanded(
// //           child: Container(
// //             padding: const EdgeInsets.all(16),
// //             color: AppColor.primary,
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: <Widget>[
// //                 AnalogLogo(),
// //                 Container(height: 16),
// //                 LoginTitle(),
// //                 Container(height: 16),
// //                 Visibility(
// //                   visible: state.onPage == OnPage.inputEmail,
// //                   replacement: LoginInputPassword(),
// //                   child: const LoginTextField(),
// //                 ),
// //                 LoginInputHint(),
// //                 LoginCTA()
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
