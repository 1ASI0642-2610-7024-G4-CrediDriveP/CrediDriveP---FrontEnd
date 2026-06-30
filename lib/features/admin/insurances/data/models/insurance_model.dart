class InsuranceModel {
  final int id;
  final String name;
  final String type; // DESGRAVAMEN / VEHICULAR / OTHER
  final double rate;
  final String base; // SALDO_INSOLUTO / VALOR_VEHICULO / MONTO_PRESTAMO
  final bool isMandatory;
  final bool isActive;

  const InsuranceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.rate,
    required this.base,
    required this.isMandatory,
    required this.isActive,
  });

  factory InsuranceModel.fromJson(Map<String, dynamic> json) {
    return InsuranceModel(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      rate: (json['rate'] as num).toDouble(),
      base: json['base'] as String? ?? 'SALDO_INSOLUTO',
      isMandatory: json['isMandatory'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}