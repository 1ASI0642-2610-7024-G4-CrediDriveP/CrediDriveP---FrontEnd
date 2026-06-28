import '../../domain/entities/client.dart';

class ClientModel extends Client {
  const ClientModel({
    required super.id,
    required super.dni,
    required super.firstName,
    required super.lastName,
    required super.fullName,
    required super.phone,
    required super.monthlyIncome,
    required super.creditScore,
    required super.isActive,
    required super.createdByName,
    required super.createdAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as int,
      dni: json['dni'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      fullName: json['fullName'] as String? ?? '${json['firstName']} ${json['lastName']}',
      phone: json['phone'] as String? ?? '',
      monthlyIncome: (json['monthlyIncome'] as num).toDouble(),
      creditScore: json['creditScore'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdByName: json['createdByName'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'dni': dni,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'monthlyIncome': monthlyIncome,
        'creditScore': creditScore,
      };
}