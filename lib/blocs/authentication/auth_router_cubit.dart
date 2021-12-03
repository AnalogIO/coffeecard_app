import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthRoute { entry, home }

class AuthRouterCubit extends Cubit<AuthRoute> {
  AuthRouterCubit() : super(AuthRoute.entry);

  void changeRoute(AuthRoute route) => emit(route);
}
