import 'package:equatable/equatable.dart';

import '../../domain/models/education.dart';

class EducationModel extends Equatable {
  final String id;
  final String institution;
  final String fieldOfStudy;
  final String? typeOfDegree;
  final String startDate;
  final String? endDate;
  final String? summary;

  const EducationModel({
    required this.id,
    required this.institution,
    required this.fieldOfStudy,
    this.typeOfDegree,
    required this.startDate,
    this.endDate,
    this.summary,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      id: json['id'] as String,
      institution: json['institution'] as String,
      fieldOfStudy: json['fieldOfStudy'] as String,
      typeOfDegree: json['typeOfDegree'] as String?,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String?,
      summary: json['summary'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'institution': institution,
      'fieldOfStudy': fieldOfStudy,
      'typeOfDegree': typeOfDegree,
      'startDate': startDate,
      'endDate': endDate,
      'summary': summary,
    };
  }

  // Assuming you have a corresponding domain model called Education
  Education toDomain() {
    return Education(
      id: id,
      institution: institution,
      fieldOfStudy: fieldOfStudy,
      typeOfDegree: typeOfDegree,
      startDate: DateTime.parse(startDate),
      endDate: endDate != null ? DateTime.parse(endDate!) : null,
      summary: summary,
    );
  }

  factory EducationModel.fromDomain(Education education) {
    return EducationModel(
      id: education.id,
      institution: education.institution,
      fieldOfStudy: education.fieldOfStudy,
      typeOfDegree: education.typeOfDegree,
      startDate: education.startDate.toIso8601String(),
      endDate: education.endDate?.toIso8601String(),
      summary: education.summary,
    );
  }

  @override
  List<Object> get props => [
        id,
        institution,
        fieldOfStudy,
        startDate,
      ];
}
