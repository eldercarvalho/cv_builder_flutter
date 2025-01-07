import 'package:cv_builder/domain/models/award.dart';
import 'package:equatable/equatable.dart';

class AwardModel extends Equatable {
  final String id;
  final String title;
  final String awarder;
  final String date;
  final String? summary;

  const AwardModel({
    required this.id,
    required this.title,
    required this.awarder,
    required this.date,
    this.summary,
  });

  factory AwardModel.fromJson(Map<String, dynamic> json) {
    return AwardModel(
      id: json['id'] as String,
      title: json['title'] as String,
      awarder: json['awarder'] as String,
      date: json['date'] as String,
      summary: json['summary'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'awarder': awarder,
      'date': date,
      'summary': summary,
    };
  }

  Award toDomain() {
    return Award(
      id: id,
      title: title,
      awarder: awarder,
      date: DateTime.parse(date),
      summary: summary,
    );
  }

  static AwardModel fromDomain(Award award) {
    return AwardModel(
      id: award.id,
      title: award.title,
      awarder: award.awarder,
      date: award.date.toIso8601String(),
      summary: award.summary,
    );
  }

  @override
  List<Object> get props => [id, title, awarder, date];
}
