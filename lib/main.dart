import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/theme.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/data/repositories/v2/app_config_repository.dart';
import 'package:coffeecard/firebase_options.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/pages/splash/splash_error_page.dart';
import 'package:coffeecard/widgets/pages/splash/splash_loading_page.dart';
import 'package:coffeecard/widgets/routers/splash_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  configureServices();

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(App());
}

class App extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  EnvironmentCubit _createEnvironmentCubit(BuildContext _) {
    final repo = sl.get<AppConfigRepository>();
    return EnvironmentCubit(repo)..getConfig();
  }

  @override
  Widget build(BuildContext context) {
    // Force screen orientation to portrait
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<AuthenticationCubit>()..appStarted()),
        BlocProvider(create: _createEnvironmentCubit),
      ],
      child: SplashRouter(
        navigatorKey: _navigatorKey,
        child: MaterialApp(
          title: Strings.appTitle,
          theme: analogTheme,
          navigatorKey: _navigatorKey,
          home: BlocBuilder<EnvironmentCubit, EnvironmentState>(
            builder: (_, state) {
              return (state is EnvironmentError)
                  ? const SplashErrorPage()
                  : const SplashLoadingPage();
            },
          ),
        ),
      ),
    );
  }
}
