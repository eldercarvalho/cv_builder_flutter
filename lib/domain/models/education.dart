import 'package:equatable/equatable.dart';

class Education extends Equatable {
  final String id;
  final String institution;
  final String fieldOfStudy;
  final String? typeOfDegree;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? summary;

  const Education({
    required this.id,
    required this.institution,
    required this.fieldOfStudy,
    this.typeOfDegree,
    required this.startDate,
    this.endDate,
    this.summary,
  });

  @override
  List<Object?> get props => [
        id,
        institution,
        fieldOfStudy,
        startDate,
        endDate,
        summary,
        typeOfDegree,
      ];
}
