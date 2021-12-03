import 'package:flutter_bloc/flutter_bloc.dart';

enum EntryRoute { login, register }

class EntryRouterCubit extends Cubit<EntryRoute> {
  EntryRouterCubit() : super(EntryRoute.login);

  void changeRoute(EntryRoute route) => emit(route);
}
