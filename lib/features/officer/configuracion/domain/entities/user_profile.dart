import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String name;
  final String email;
  final String role;

  const UserProfile({
    required this.name,
    required this.email,
    required this.role,
  });

  bool get isAdmin => role == 'ADMIN';

  @override
  List<Object> get props => [email, role];
}