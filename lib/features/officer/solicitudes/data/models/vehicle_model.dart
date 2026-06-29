import '../../domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  const VehicleModel({
    required super.id,
    required super.brand,
    required super.model,
    required super.year,
    required super.condition,
    required super.price,
    required super.priceCurrency,
    super.vin,
    super.imageUrl,
    required super.stock,
    required super.status,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as int,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      condition: json['condition'] as String,
      price: (json['price'] as num).toDouble(),
      priceCurrency: json['priceCurrency'] as String? ?? 'USD',
      vin: json['vin'] as String?,
      imageUrl: json['imageUrl'] as String?,
      stock: json['stock'] as int? ?? 0,
      status: json['status'] as String? ?? 'AVAILABLE',
    );
  }

  Map<String, dynamic> toJson() => {
        'brand': brand,
        'model': model,
        'year': year,
        'condition': condition,
        'price': price,
        'priceCurrency': priceCurrency,
        'vin': vin,
        'imageUrl': imageUrl,
        'stock': stock,
      };
}