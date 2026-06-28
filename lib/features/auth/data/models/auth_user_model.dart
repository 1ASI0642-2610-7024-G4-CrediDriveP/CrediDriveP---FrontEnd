import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.token,
    required super.name,
    required super.email,
    required super.role,
    required super.expiresAt,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      token: json['token'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'name': name,
        'email': email,
        'role': role,
        'expiresAt': expiresAt.toIso8601String(),
      };
}
