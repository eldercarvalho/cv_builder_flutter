import 'package:equatable/equatable.dart';

class Hobbie extends Equatable {
  final String id;
  final String name;

  const Hobbie({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}
