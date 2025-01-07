import 'package:equatable/equatable.dart';

import '../../domain/models/hobbie.dart';

class HobbieModel extends Equatable {
  final String id;
  final String name;

  const HobbieModel({required this.id, required this.name});

  factory HobbieModel.fromJson(Map<String, dynamic> json) {
    return HobbieModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory HobbieModel.fromDomain(Hobbie domain) {
    return HobbieModel(
      id: domain.id,
      name: domain.name,
    );
  }

  Hobbie toDomain() {
    return Hobbie(
      id: id,
      name: name,
    );
  }

  @override
  List<Object> get props => [id, name];
}
