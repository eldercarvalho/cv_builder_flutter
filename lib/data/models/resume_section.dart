import 'package:equatable/equatable.dart';

import '../../domain/models/resume.dart';
import '../../domain/models/resume_section.dart';

class ResumeSectionModel extends Equatable {
  final String type;
  final String title;
  final bool hideTitle;
  final bool forcePageBreak;
  final String layout;
  final bool hideDivider;
  final bool hasLayout;
  const ResumeSectionModel({
    required this.type,
    required this.title,
    this.hideTitle = false,
    this.forcePageBreak = false,
    this.layout = 'list',
    this.hideDivider = false,
    this.hasLayout = false,
  });

  factory ResumeSectionModel.fromJson(Map<String, dynamic> json) {
    return ResumeSectionModel(
      type: json['type'],
      title: json['title'],
      hideTitle: json['hideTitle'],
      forcePageBreak: json['forcePageBreak'],
      layout: json['layout'] ?? 'list',
      hideDivider: json['hideDivider'] ?? false,
      hasLayout: json['hasLayout'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'hideTitle': hideTitle,
      'forcePageBreak': forcePageBreak,
      'layout': layout,
      'hideDivider': hideDivider,
      'hasLayout': hasLayout,
    };
  }

  factory ResumeSectionModel.fromDomain(ResumeSection section) {
    return ResumeSectionModel(
      type: section.type.name,
      title: section.title,
      hideTitle: section.hideTitle,
      forcePageBreak: section.forcePageBreak,
      layout: section.layout.name,
      hideDivider: section.hideDivider,
      hasLayout: section.hasLayout,
    );
  }

  ResumeSection toDomain() {
    return ResumeSection(
      type: ResumeSectionType.values.firstWhere((e) => e.name == type),
      title: title,
      hideTitle: hideTitle,
      forcePageBreak: forcePageBreak,
      layout: ResumeSectionLayout.values.firstWhere((e) => e.name == layout),
      hideDivider: hideDivider,
      hasLayout: hasLayout,
    );
  }

  static List<ResumeSectionModel> getSectionsByTemplate(String template) {
    return Resume.createSectionsByTemplate(template: ResumeTemplate.fromString(template))
        .map((e) => ResumeSectionModel.fromDomain(e))
        .toList();
  }

  @override
  List<Object?> get props => [title, hideTitle, forcePageBreak, layout, hideDivider];
}
