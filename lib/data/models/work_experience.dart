import 'package:equatable/equatable.dart';

import '../../domain/models/work_experience.dart';

class WorkExperienceModel extends Equatable {
  final String id;
  final String company;
  final String position;
  final String website;
  final String startDate;
  final String? endDate;
  final String? summary;

  const WorkExperienceModel({
    required this.id,
    required this.company,
    required this.position,
    required this.website,
    required this.startDate,
    this.endDate,
    this.summary,
  });

  factory WorkExperienceModel.fromJson(Map<String, dynamic> json) {
    return WorkExperienceModel(
      id: json['id'] as String,
      company: json['company'] as String,
      position: json['position'] as String,
      website: json['website'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      summary: json['summary'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company,
      'position': position,
      'website': website,
      'startDate': startDate,
      'endDate': endDate,
      'summary': summary,
    };
  }

  factory WorkExperienceModel.fromDomain(WorkExperience domain) {
    return WorkExperienceModel(
      id: domain.id,
      company: domain.company,
      position: domain.position,
      website: domain.website,
      startDate: domain.startDate.toIso8601String(),
      endDate: domain.endDate?.toIso8601String(),
      summary: domain.summary,
    );
  }

  WorkExperience toDomain() {
    return WorkExperience(
      id: id,
      company: company,
      position: position,
      website: website,
      startDate: DateTime.parse(startDate),
      endDate: endDate != null ? DateTime.parse(endDate!) : null,
      summary: summary,
    );
  }

  WorkExperienceModel copyWith({
    String? id,
    String? company,
    String? position,
    String? website,
    String? startDate,
    String? endDate,
    String? summary,
  }) {
    return WorkExperienceModel(
      id: id ?? this.id,
      company: company ?? this.company,
      position: position ?? this.position,
      website: website ?? this.website,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      summary: summary ?? this.summary,
    );
  }

  @override
  List<Object> get props => [
        id,
        company,
        position,
        website,
        startDate,
      ];
}
