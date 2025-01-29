import 'package:equatable/equatable.dart';

import '../../domain/models/user.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  User toDomain() {
    return User(
      id: id,
      name: name,
      email: email,
    );
  }

  @override
  List<Object?> get props => [id, name, email];
}
