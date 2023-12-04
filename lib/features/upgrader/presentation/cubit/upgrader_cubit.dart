import 'package:bloc/bloc.dart';
import 'package:coffeecard/features/upgrader/domain/usecases/can_upgrade.dart';
import 'package:equatable/equatable.dart';

part 'upgrader_state.dart';

class UpgraderCubit extends Cubit<UpgraderState> {
  final CanUpgrade canUpgrade;

  UpgraderCubit({required this.canUpgrade}) : super(UpgraderLoading());

  Future<void> load() async {
    final uppgradeAvailable = await canUpgrade();

    uppgradeAvailable.match(
      //FIXME: error message
      () => emit(const UpgraderError(error: 'some error')),
      (upgradeAvailable) => emit(UpgraderLoaded(canUpgrade: upgradeAvailable)),
    );
  }
}
