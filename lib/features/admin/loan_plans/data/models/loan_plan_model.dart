int _readInt(Map<String, dynamic> json, List<String> keys, {required int defaultValue}) {
  for (final key in keys) {
    final value = json[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
  }
  return defaultValue;
}

String _readString(Map<String, dynamic> json, List<String> keys, {required String defaultValue}) {
  for (final key in keys) {
    final value = json[key];
    if (value is String) return value;
  }
  return defaultValue;
}

double _readDouble(Map<String, dynamic> json, List<String> keys, {required double defaultValue}) {
  for (final key in keys) {
    final value = json[key];
    if (value is num) return value.toDouble();
  }
  return defaultValue;
}

bool _readBool(Map<String, dynamic> json, List<String> keys, {required bool defaultValue}) {
  for (final key in keys) {
    final value = json[key];
    if (value is bool) return value;
  }
  return defaultValue;
}

List<int> _readIntList(Map<String, dynamic> json, List<String> keys, {required List<int> defaultValue}) {
  for (final key in keys) {
    final value = json[key];
    if (value is List) {
      return value.whereType<num>().map((e) => e.toInt()).toList();
    }
  }
  return defaultValue;
}

List<Map<String, dynamic>> _readObjectList(
  Map<String, dynamic> json,
  List<String> keys, {
  required List<Map<String, dynamic>> defaultValue,
}) {
  for (final key in keys) {
    final value = json[key];
    if (value is List) {
      return value
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
  }
  return defaultValue;
}

class LoanPlanModel {
  final int id;
  final String name;
  final String currency;
  final String rateType;
  final double interestRate;
  final int termMonths;
  final String graceType;
  final int graceMonths;
  final String paymentMethod;
  final double cokAnnual;
  final bool isActive;
  final List<int> insuranceIds;
  final List<int> commissionIds;
  final List<Map<String, dynamic>> insurances;
  final List<Map<String, dynamic>> commissions;

  const LoanPlanModel({
    required this.id,
    required this.name,
    required this.currency,
    required this.rateType,
    required this.interestRate,
    required this.termMonths,
    required this.graceType,
    required this.graceMonths,
    required this.paymentMethod,
    required this.cokAnnual,
    required this.isActive,
    required this.insuranceIds,
    required this.commissionIds,
    required this.insurances,
    required this.commissions,
  });

  factory LoanPlanModel.fromJson(Map<String, dynamic> json) {
    return LoanPlanModel(
      id: _readInt(json, ['id', 'loanPlanId', 'planId'], defaultValue: 0),
      name: _readString(json, ['name', 'planName'], defaultValue: 'Sin nombre'),
      currency: _readString(json, ['currency'], defaultValue: 'PEN'),
      rateType: _readString(json, ['rateType'], defaultValue: 'TEA'),
      interestRate: _readDouble(json, ['interestRate'], defaultValue: 0),
      termMonths: _readInt(json, ['termMonths'], defaultValue: 0),
      graceType: _readString(json, ['graceType'], defaultValue: 'NONE'),
      graceMonths: _readInt(json, ['graceMonths'], defaultValue: 0),
      paymentMethod: _readString(json, ['paymentMethod'], defaultValue: 'FRENCH'),
      cokAnnual: _readDouble(json, ['cokAnnual'], defaultValue: 0),
      isActive: _readBool(json, ['isActive', 'active'], defaultValue: true),
      insuranceIds: _readIntList(json, ['insuranceIds'], defaultValue: const []),
      commissionIds: _readIntList(json, ['commissionIds'], defaultValue: const []),
      insurances: _readObjectList(json, ['insurances'], defaultValue: const []),
      commissions: _readObjectList(json, ['commissions'], defaultValue: const []),
    );
  }

  // Badge de tipo de plan basado en el nombre
  String get planType {
    final n = name.toLowerCase();
    if (n.contains('premium') || n.contains('luxury')) return 'PREMIUM';
    if (n.contains('pyme') || n.contains('cargo') || n.contains('work')) {
      return 'VANS & WORK';
    }
    return 'TRADICIONAL';
  }
}