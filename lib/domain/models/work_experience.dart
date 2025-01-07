import 'package:equatable/equatable.dart';

class WorkExperience extends Equatable {
  final String id;
  final String company;
  final String position;
  final String website;
  final DateTime startDate;
  final DateTime? endDate;
  final String? summary;

  const WorkExperience({
    required this.id,
    required this.company,
    required this.position,
    required this.website,
    required this.startDate,
    this.endDate,
    this.summary,
  });

  @override
  List<Object> get props => [
        id,
        company,
        position,
        website,
        startDate,
      ];
}
