import 'package:flutter/material.dart';

class ProfileConstants {
  static final List<AvatarOption> avatarPresets = [
    AvatarOption(
      id: 0,
      color: const Color(0xFFFFC107),
      icon: Icons.sentiment_satisfied_alt,
    ),
    AvatarOption(
      id: 1,
      color: const Color(0xFF81D4FA),
      icon: Icons.sentiment_very_satisfied,
    ),
    AvatarOption(id: 2, color: const Color(0xFFFF4081), icon: Icons.favorite),
    AvatarOption(id: 3, color: const Color(0xFF5C6BC0), icon: Icons.star),
    AvatarOption(
      id: 4,
      color: const Color(0xFF66BB6A),
      icon: Icons.emoji_emotions,
    ),
  ];
}

class AvatarOption {
  final int id;
  final Color color;
  final IconData icon;

  AvatarOption({required this.id, required this.color, required this.icon});
}
