import 'package:equatable/equatable.dart';

class Occupation extends Equatable {
  const Occupation({
    required this.id,
    required this.shortName,
    required this.fullName,
  });

  final int id;
  final String shortName;
  final String fullName;

  const Occupation.empty()
      : id = 0,
        shortName = 'None',
        fullName = 'None';

  @override
  List<Object> get props => [id, shortName, fullName];
}
