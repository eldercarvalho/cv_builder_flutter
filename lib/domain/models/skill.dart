import 'package:equatable/equatable.dart';

class Skill extends Equatable {
  final String id;
  final String name;
  final String? level;

  const Skill({
    required this.id,
    required this.name,
    this.level,
  });

  @override
  List<Object> get props => [id, name];
}
