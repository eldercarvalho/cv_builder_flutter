import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String title;
  final String? website;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? summary;

  const Project({
    required this.id,
    required this.title,
    this.website,
    this.startDate,
    this.endDate,
    this.summary,
  });

  @override
  List<Object> get props => [
        id,
        title,
      ];
}
