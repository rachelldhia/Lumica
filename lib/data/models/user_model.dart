import 'package:lumica_app/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

/// Data user model with JSON serialization
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.username,
    super.displayName,
    super.avatarUrl,
    super.createdAt,
    super.updatedAt,
  });

  /// Create UserModel from Supabase Auth User (auth.users)
  factory UserModel.fromSupabaseAuth(supabase.User authUser) {
    return UserModel(
      id: authUser.id,
      email: authUser.email ?? '',
      createdAt: DateTime.parse(authUser.createdAt),
    );
  }

  /// Create UserModel from public.users JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email:
          json['email'] as String? ??
          '', // May come from join or separate query
      username: json['username'] as String?,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Merge auth user with profile data from public.users
  UserModel mergeWithProfile(Map<String, dynamic> profileData) {
    return UserModel(
      id: id,
      email: email,
      username: profileData['username'] as String?,
      displayName: profileData['display_name'] as String?,
      avatarUrl: profileData['avatar_url'] as String?,
      createdAt: createdAt,
      updatedAt: profileData['updated_at'] != null
          ? DateTime.parse(profileData['updated_at'] as String)
          : null,
    );
  }

  /// Convert UserModel to JSON (for public.users updates)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Create copy with updated fields
  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? displayName,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
