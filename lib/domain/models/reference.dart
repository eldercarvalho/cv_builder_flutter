import 'package:equatable/equatable.dart';

class Reference extends Equatable {
  final String id;
  final String name;
  final String position;
  final String phoneNumber;
  final String? email;
  final String? summary;

  const Reference({
    required this.id,
    required this.name,
    required this.position,
    required this.phoneNumber,
    this.email,
    this.summary,
  });

  @override
  List<Object> get props => [
        id,
        name,
        position,
        phoneNumber,
      ];
}
