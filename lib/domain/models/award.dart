import 'package:equatable/equatable.dart';

class Award extends Equatable {
  final String id;
  final String title;
  final String awarder;
  final DateTime date;
  final String? summary;

  const Award({
    required this.id,
    required this.title,
    required this.awarder,
    required this.date,
    this.summary,
  });

  @override
  List<Object> get props => [id, title, awarder, date];
}
