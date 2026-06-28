import 'package:equatable/equatable.dart';

class Client extends Equatable {
  final int id;
  final String dni;
  final String firstName;
  final String lastName;
  final String fullName;
  final String phone;
  final double monthlyIncome;
  final int creditScore;
  final bool isActive;
  final String createdByName;
  final DateTime createdAt;

  const Client({
    required this.id,
    required this.dni,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.phone,
    required this.monthlyIncome,
    required this.creditScore,
    required this.isActive,
    required this.createdByName,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, dni];
}