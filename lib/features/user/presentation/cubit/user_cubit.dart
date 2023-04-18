import 'package:bloc/bloc.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/features/user/domain/usecases/get_user.dart';
import 'package:coffeecard/features/user/domain/usecases/request_account_deletion.dart';
import 'package:coffeecard/features/user/domain/usecases/update_user_details.dart';
import 'package:coffeecard/models/account/update_user.dart';
import 'package:coffeecard/utils/encode_passcode.dart';
import 'package:equatable/equatable.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUser getUser;
  final UpdateUserDetails updateUserDetails;
  final RequestAccountDeletion requestAccountDeletion;

  UserCubit({
    required this.getUser,
    required this.updateUserDetails,
    required this.requestAccountDeletion,
  }) : super(UserLoading());

  Future<void> init() async {
    await fetchUserDetails();
    if (state is UserLoaded) {
      emit(UserInitiallyLoaded(state as UserLoaded));
    }
  }

  Future<void> fetchUserDetails() async {
    emit(UserLoading());

    final either = await getUser(NoParams());

    either.fold(
      (error) => emit(UserError(error.reason)),
      (user) => emit(UserLoaded(user: user)),
    );
  }

  Future<void> updateUser(UpdateUser user) async {
    if (state is! UserLoaded) {
      return;
    }

    final loadedState = state as UserLoaded;

    emit(UserUpdating(user: loadedState.user));

    final either = await updateUserDetails(
      Params(
        email: user.email,
        encodedPasscode: user.encodedPasscode,
        name: user.name,
        occupationId: user.occupationId,
        privacyActivated: user.privacyActivated,
      ),
    );

    either.fold(
      (error) => emit(UserError(error.reason)),
      (user) => emit(loadedState.copyWith(user: user)),
    );
  }

  Future<void> setUserPrivacy({required bool privacyActivated}) async {
    updateUser(UpdateUser(privacyActivated: privacyActivated));
  }

  Future<void> setUserName(String name) async {
    updateUser(UpdateUser(name: name));
  }

  Future<void> setUserEmail(String email) async {
    updateUser(UpdateUser(email: email));
  }

  Future<void> setUserPasscode(String passcode) async {
    updateUser(UpdateUser(encodedPasscode: encodePasscode(passcode)));
  }

  Future<void> setUserOccupation(int occupationId) async {
    updateUser(UpdateUser(occupationId: occupationId));
  }

  void requestUserAccountDeletion() {
    requestAccountDeletion(NoParams());
  }
}
