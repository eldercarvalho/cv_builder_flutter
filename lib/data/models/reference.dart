import 'package:equatable/equatable.dart';

import '../../domain/models/reference.dart';

class ReferenceModel extends Equatable {
  final String id;
  final String name;
  final String position;
  final String phoneNumber;
  final String? email;
  final String? summary;

  const ReferenceModel({
    required this.id,
    required this.name,
    required this.position,
    required this.phoneNumber,
    this.email,
    this.summary,
  });

  factory ReferenceModel.fromJson(Map<String, dynamic> json) {
    return ReferenceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      position: json['position'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      summary: json['summary'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'phoneNumber': phoneNumber,
      'email': email,
      'summary': summary,
    };
  }

  Reference toDomain() {
    return Reference(
      id: id,
      name: name,
      position: position,
      phoneNumber: phoneNumber,
      email: email,
      summary: summary,
    );
  }

  factory ReferenceModel.fromDomain(Reference reference) {
    return ReferenceModel(
      id: reference.id,
      name: reference.name,
      position: reference.position,
      phoneNumber: reference.phoneNumber,
      email: reference.email,
      summary: reference.summary,
    );
  }

  @override
  List<Object> get props => [
        id,
        name,
        position,
        phoneNumber,
      ];
}
