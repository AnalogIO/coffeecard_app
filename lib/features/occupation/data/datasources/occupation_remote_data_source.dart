import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/features/occupation/data/models/occupation_model.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';

abstract class OccupationRemoteDataSource {
  Future<List<OccupationModel>> getOccupations();
}

class OccupationRemoteDataSourceImpl implements OccupationRemoteDataSource {
  final CoffeecardApi api;

  OccupationRemoteDataSourceImpl({required this.api});

  @override
  Future<List<OccupationModel>> getOccupations() async {
    final response = await api.apiV1ProgrammesGet();

    if (!response.isSuccessful) {
      throw ServerException.fromResponse(response);
    }

    return response.body!.map(OccupationModel.fromDTO).toList();
  }
}
