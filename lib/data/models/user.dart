import 'package:equatable/equatable.dart';

import '../../domain/models/user.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  User toDomain() {
    return User(
      id: id,
      name: name,
      email: email,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static UserModel fromDomain(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, email, createdAt, updatedAt];
}
