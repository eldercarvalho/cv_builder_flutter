import 'package:equatable/equatable.dart';

import '../../domain/models/language.dart';

class LanguageModel extends Equatable {
  final String id;
  final String name;
  final String? fluency;

  const LanguageModel({
    required this.id,
    required this.name,
    this.fluency,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      id: json['id'] as String,
      name: json['name'] as String,
      fluency: json['fluency'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fluency': fluency,
    };
  }

  Language toDomain() {
    return Language(
      id: id,
      name: name,
      fluency: fluency,
    );
  }

  factory LanguageModel.fromDomain(Language language) {
    return LanguageModel(
      id: language.id,
      name: language.name,
      fluency: language.fluency,
    );
  }

  @override
  List<Object> get props => [id, name];
}
