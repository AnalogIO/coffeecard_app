import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';
import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  const MenuItem({required this.id, required this.name});

  factory MenuItem.fromResponse(MenuItemResponse response) =>
      MenuItem(id: response.id, name: response.name);

  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
