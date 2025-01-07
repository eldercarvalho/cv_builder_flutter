import 'package:equatable/equatable.dart';

import '../../domain/models/project.dart';

class ProjectModel extends Equatable {
  final String id;
  final String title;
  final String? website;
  final String? startDate;
  final String? endDate;
  final String? summary;

  const ProjectModel({
    required this.id,
    required this.title,
    this.website,
    this.startDate,
    this.endDate,
    this.summary,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      title: json['title'] as String,
      website: json['website'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      summary: json['summary'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'website': website,
      'startDate': startDate,
      'endDate': endDate,
      'summary': summary,
    };
  }

  Project toDomain() {
    return Project(
      id: id,
      title: title,
      website: website,
      startDate: startDate != null ? DateTime.parse(startDate!) : null,
      endDate: endDate != null ? DateTime.parse(endDate!) : null,
      summary: summary,
    );
  }

  factory ProjectModel.fromDomain(Project project) {
    return ProjectModel(
      id: project.id,
      title: project.title,
      website: project.website,
      startDate: project.startDate?.toIso8601String(),
      endDate: project.endDate?.toIso8601String(),
      summary: project.summary,
    );
  }

  @override
  List<Object> get props => [
        id,
        title,
      ];
}
