import 'package:equatable/equatable.dart';

import '../../domain/models/resume.dart';
import '../../domain/models/resume_section.dart';

class ResumeSectionModel extends Equatable {
  final String type;
  final String title;
  final bool hideTitle;
  final bool forcePageBreak;

  const ResumeSectionModel({
    required this.type,
    required this.title,
    this.hideTitle = false,
    this.forcePageBreak = false,
  });

  factory ResumeSectionModel.fromJson(Map<String, dynamic> json) {
    return ResumeSectionModel(
      type: json['type'],
      title: json['title'],
      hideTitle: json['hideTitle'],
      forcePageBreak: json['forcePageBreak'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'hideTitle': hideTitle,
      'forcePageBreak': forcePageBreak,
    };
  }

  factory ResumeSectionModel.fromDomain(ResumeSection section) {
    return ResumeSectionModel(
      type: section.type.name,
      title: section.title,
      hideTitle: section.hideTitle,
      forcePageBreak: section.forcePageBreak,
    );
  }

  ResumeSection toDomain() {
    return ResumeSection(
      type: ResumeSectionType.values.firstWhere((e) => e.name == type),
      title: title,
      hideTitle: hideTitle,
      forcePageBreak: forcePageBreak,
    );
  }

  static List<ResumeSectionModel> getSectionsByTemplate(String template) {
    return Resume.createSectionsByTemplate(template: ResumeTemplate.fromString(template))
        .map((e) => ResumeSectionModel.fromDomain(e))
        .toList();
  }

  @override
  List<Object?> get props => [title, hideTitle, forcePageBreak];
}
