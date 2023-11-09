import 'package:bloc/bloc.dart';
import 'package:coffeecard/core/encode_passcode.dart';
import 'package:coffeecard/features/user/domain/entities/update_user.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/features/user/domain/usecases/get_user.dart';
import 'package:coffeecard/features/user/domain/usecases/request_account_deletion.dart';
import 'package:coffeecard/features/user/domain/usecases/update_user_details.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUser getUser;
  final UpdateUserDetails updateUserDetails;
  final RequestAccountDeletion requestAccountDeletion;

  UserCubit({
    required this.getUser,
    required this.updateUserDetails,
    required this.requestAccountDeletion,
  }) : super(const UserLoading());

  Future<void> _fetchUserDetails({required bool firstLoad}) async {
    emit(const UserLoading());
    emit(
      switch (await getUser()) {
        Left(value: final failure) => UserError(failure.reason),
        Right(value: final user) when firstLoad => UserInitiallyLoaded(user),
        Right(value: final user) => UserLoaded(user),
      },
    );
  }

  Future<void> initialize() => _fetchUserDetails(firstLoad: true);
  Future<void> fetchUserDetails() => _fetchUserDetails(firstLoad: false);

  Future<void> updateUser(UpdateUser user) async {
    final state = this.state;
    if (state is! UserLoaded) {
      return;
    }

    emit(UserUpdating(state.user));

    final result = await updateUserDetails(
      email: user.email,
      encodedPasscode: user.encodedPasscode,
      name: user.name,
      occupationId: user.occupationId,
      privacyActivated: user.privacyActivated,
    );

    emit(
      result.fold(
        (error) => UserError(error.reason),
        (user) => UserLoaded(user),
      ),
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
    requestAccountDeletion().ignore();
  }
}
