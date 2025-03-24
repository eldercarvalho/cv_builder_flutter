import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

enum ResumeSectionType {
  contact,
  socialNetworks,
  address,
  objective,
  experience,
  education,
  skills,
  languages,
  certifications,
  projects,
  references,
  hobbies;

  static ResumeSectionType fromString(String value) {
    return ResumeSectionType.values.firstWhere((e) => e.toString() == value);
  }
}

class ResumeSection extends Equatable {
  final ResumeSectionType type;
  final String title;
  final bool hideTitle;
  final bool forcePageBreak;

  const ResumeSection({
    required this.type,
    required this.title,
    this.hideTitle = false,
    this.forcePageBreak = false,
  });

  ResumeSection copyWith({
    ResumeSectionType? type,
    String? title,
    bool? hideTitle,
    bool? forcePageBreak,
  }) {
    return ResumeSection(
      type: type ?? this.type,
      title: title ?? this.title,
      hideTitle: hideTitle ?? this.hideTitle,
      forcePageBreak: forcePageBreak ?? this.forcePageBreak,
    );
  }

  @override
  List<Object?> get props => [title, hideTitle, forcePageBreak];
}

extension ResumeSectionExtension on List<ResumeSection> {
  List<ResumeSection> getSectionsByType(ResumeSectionType type) {
    return where((element) => element.type == type).toList();
  }

  ResumeSection? getByType(ResumeSectionType type) {
    return firstWhereOrNull((element) => element.type == type);
  }

  ResumeSection get contact => getByType(ResumeSectionType.contact)!;
  ResumeSection get socialNetworks => getByType(ResumeSectionType.socialNetworks)!;
  ResumeSection get address => getByType(ResumeSectionType.address)!;
  ResumeSection get objective => getByType(ResumeSectionType.objective)!;
  ResumeSection get experience => getByType(ResumeSectionType.experience)!;
  ResumeSection get education => getByType(ResumeSectionType.education)!;
  ResumeSection get skills => getByType(ResumeSectionType.skills)!;
  ResumeSection get languages => getByType(ResumeSectionType.languages)!;
  ResumeSection get certifications => getByType(ResumeSectionType.certifications)!;
  ResumeSection get projects => getByType(ResumeSectionType.projects)!;
  ResumeSection get references => getByType(ResumeSectionType.references)!;
  ResumeSection get hobbies => getByType(ResumeSectionType.hobbies)!;
}
