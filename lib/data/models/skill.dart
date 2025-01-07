import 'package:cv_builder/domain/models/skill.dart';
import 'package:equatable/equatable.dart';

class SkillModel extends Equatable {
  final String id;
  final String name;
  final String? level;

  const SkillModel({
    required this.id,
    required this.name,
    this.level,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'] as String,
      name: json['name'] as String,
      level: json['level'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
    };
  }

  Skill toDomain() {
    return Skill(
      id: id,
      name: name,
      level: level,
    );
  }

  factory SkillModel.fromDomain(Skill skill) {
    return SkillModel(
      id: skill.id,
      name: skill.name,
      level: skill.level,
    );
  }

  @override
  List<Object> get props => [id, name];
}
