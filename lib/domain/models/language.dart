import 'package:equatable/equatable.dart';

class Language extends Equatable {
  final String id;
  final String name;
  final String? fluency;

  const Language({
    required this.id,
    required this.name,
    this.fluency,
  });

  @override
  List<Object> get props => [id, name];
}
