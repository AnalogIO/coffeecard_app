import 'package:equatable/equatable.dart';

class Contributor extends Equatable {
  final String name;
  final String avatarUrl;
  final String githubUrl;

  const Contributor({
    required this.name,
    required this.avatarUrl,
    required this.githubUrl,
  });

  @override
  List<Object?> get props => [name, avatarUrl, githubUrl];
}
