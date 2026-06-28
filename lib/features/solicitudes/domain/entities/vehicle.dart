import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  final int id;
  final String brand;
  final String model;
  final int year;
  final String condition; // 'NEW' | 'USED'
  final double price;
  final String priceCurrency; // 'PEN' | 'USD'
  final String? vin;
  final String? imageUrl;
  final int stock;
  final String status; // 'AVAILABLE' | 'SOLD' | 'RESERVED'

  const Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.condition,
    required this.price,
    required this.priceCurrency,
    this.vin,
    this.imageUrl,
    required this.stock,
    required this.status,
  });

  String get displayName => '$brand $model $year';

  bool get isAvailable => status == 'AVAILABLE';

  @override
  List<Object?> get props => [id, vin];
}