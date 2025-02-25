import 'package:equatable/equatable.dart';

class SocialNetwork extends Equatable {
  final String id;
  final String name;
  final String? username;
  final String? url;

  const SocialNetwork({
    required this.id,
    required this.name,
    this.username,
    this.url,
  });

  @override
  List<Object?> get props => [id, name, username, url];
}

const availableSocialNetworks = [
  'Instagram',
  'Facebook',
  'LinkedIn',
  'Twitter',
  'GitHub',
  'Stack Overflow',
  'YouTube',
  'Medium',
  'Behance',
  'Dribbble',
  'Pinterest',
  'TikTok',
  'Tumblr',
  'Skype',
  // 'Telegram',
  'Twitch',
  'Discord',
];
