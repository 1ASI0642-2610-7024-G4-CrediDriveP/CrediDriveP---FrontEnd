import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String token;
  final String name;
  final String email;
  final String role; // 'ADMIN' | 'OFFICER'
  final DateTime expiresAt;

  const AuthUser({
    required this.token,
    required this.name,
    required this.email,
    required this.role,
    required this.expiresAt,
  });

  bool get isAdmin => role == 'ADMIN';
  bool get isOfficer => role == 'OFFICER';

  @override
  List<Object> get props => [token, email, role];
}
