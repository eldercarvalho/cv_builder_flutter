import 'package:equatable/equatable.dart';

class Certification extends Equatable {
  final String id;
  final String title;
  final String issuer;
  final DateTime? date;
  final String? summary;

  const Certification({
    required this.id,
    required this.title,
    required this.issuer,
    required this.date,
    this.summary,
  });

  @override
  List<Object?> get props => [id, title, issuer, date];
}
