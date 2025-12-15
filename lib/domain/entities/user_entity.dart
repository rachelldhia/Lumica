import 'package:equatable/equatable.dart';

/// Domain user entity
class UserEntity extends Equatable {
  final String id;
  final String email; // Read-only from auth.users
  final String? username; // Editable from public.users
  final String? displayName; // Editable from public.users
  final String? avatarUrl;
  final String? location; // User's selected location
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.username,
    this.displayName,
    this.avatarUrl,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    username,
    displayName,
    avatarUrl,
    location,
    createdAt,
    updatedAt,
  ];
}
