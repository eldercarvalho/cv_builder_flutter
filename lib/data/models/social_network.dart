import 'package:equatable/equatable.dart';

import '../../domain/models/social_network.dart';

class SocialNetworkModel extends Equatable {
  final String id;
  final String name;
  final String? username;
  final String? url;

  const SocialNetworkModel({
    required this.id,
    required this.name,
    this.username,
    this.url,
  });

  factory SocialNetworkModel.fromJson(Map<String, dynamic> json) {
    return SocialNetworkModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'url': url,
    };
  }

  SocialNetwork toDomain() {
    return SocialNetwork(
      id: id,
      name: name,
      username: username,
      url: url,
    );
  }

  factory SocialNetworkModel.fromDomain(SocialNetwork domain) {
    return SocialNetworkModel(
      id: domain.id,
      name: domain.name,
      username: domain.username,
      url: domain.url,
    );
  }

  @override
  List<Object?> get props => [id, name, username, url];
}
