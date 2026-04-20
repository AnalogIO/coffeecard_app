import 'package:equatable/equatable.dart';

class LeaderboardUser extends Equatable {
  final int id;
  final int rank;
  final int score;
  final String name;
  final bool highlight;
  final int? icon;
  final int? background;

  const LeaderboardUser({
    required this.id,
    required this.rank,
    required this.score,
    required this.name,
    required this.highlight,
    required this.icon,
    required this.background,
  });

  @override
  List<Object?> get props =>
      [id, rank, score, name, highlight, icon, background];
}
