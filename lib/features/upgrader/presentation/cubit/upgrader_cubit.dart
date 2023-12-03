import 'package:bloc/bloc.dart';
import 'package:coffeecard/features/upgrader/domain/usecases/get_version.dart';
import 'package:equatable/equatable.dart';

part 'upgrader_state.dart';

class UpgraderCubit extends Cubit<UpgraderState> {
  final GetVersion getVersion;

  UpgraderCubit({
    required this.getVersion,
  }) : super(UpgraderLoading());

  Future<void> load() async {
    final version = await getVersion();

    version.match(
      () =>
          emit(const UpgraderError(error: 'some error')), //FIXME: error message
      (version) => emit(UpgraderLoaded(version: version)),
    );
  }
}
