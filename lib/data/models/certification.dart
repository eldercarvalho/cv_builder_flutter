import 'package:equatable/equatable.dart';

import '../../domain/models/certification.dart';

class CertificationModel extends Equatable {
  final String id;
  final String title;
  final String issuer;
  final String? date;
  final String? summary;

  const CertificationModel({
    required this.id,
    required this.title,
    required this.issuer,
    this.date,
    this.summary,
  });

  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      issuer: json['issuer'] as String,
      date: json['date'] as String?,
      summary: json['summary'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'issuer': issuer,
      'date': date,
      'summary': summary,
    };
  }

  Certification toDomain() {
    return Certification(
      id: id,
      title: title,
      issuer: issuer,
      date: date != null && date != '' ? DateTime.parse(date!) : null,
      summary: summary,
    );
  }

  factory CertificationModel.fromDomain(Certification certification) {
    return CertificationModel(
      id: certification.id,
      title: certification.title,
      issuer: certification.issuer,
      date: certification.date?.toIso8601String(),
      summary: certification.summary,
    );
  }

  CertificationModel copyWith({
    String? id,
    String? title,
    String? issuer,
    String? date,
    String? summary,
  }) {
    return CertificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      issuer: issuer ?? this.issuer,
      date: date ?? this.date,
      summary: summary ?? this.summary,
    );
  }

  @override
  List<Object?> get props => [id, title, issuer, date];
}
