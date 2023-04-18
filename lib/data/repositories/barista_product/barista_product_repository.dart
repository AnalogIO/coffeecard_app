import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/models/environment.dart';
import 'package:coffeecard/service_locator.dart';

class BaristaProductsRepository {
  List<int> getBaristaProductIds() {
    // TODO(fredpetersen): Replace with data fetch from backend, https://github.com/AnalogIO/coffeecard_app/issues/422
    final state = sl<EnvironmentCubit>().state;
    if (state is! EnvironmentLoaded) {
      return [];
    }

    switch (state.env) {
      case Environment.production:
        return _getBaristaProductIdsProd();
      case Environment.test:
        return _getBaristaProductIdsTest();
      case Environment.unknown:
        throw ArgumentError('Unknown environment');
    }
  }

  List<int> _getBaristaProductIdsProd() {
    return const [9, 11, 12, 13];
  }

  List<int> _getBaristaProductIdsTest() {
    return const [8];
  }
}
