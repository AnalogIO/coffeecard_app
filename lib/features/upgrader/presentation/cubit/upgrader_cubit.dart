import 'package:bloc/bloc.dart';
import 'package:coffeecard/features/upgrader/domain/usecases/can_upgrade.dart';
import 'package:equatable/equatable.dart';

part 'upgrader_state.dart';

class UpgraderCubit extends Cubit<UpgraderState> {
  final CanUpgrade canUpgrade;

  UpgraderCubit({required this.canUpgrade}) : super(const UpgraderLoading());

  Future<void> load() async {
    final uppgradeAvailable = await canUpgrade();

    uppgradeAvailable.match(
      () => emit(const UpgraderLoaded(canUpgrade: false)),
      (upgradeAvailable) => emit(UpgraderLoaded(canUpgrade: upgradeAvailable)),
    );
  }
}
