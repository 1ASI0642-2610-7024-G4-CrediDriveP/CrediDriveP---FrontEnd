class CommissionModel {
  final int id;
  final String concept;
  final double amount;
  final String periodicity; // MONTHLY / ONE_TIME / ANNUAL
  final bool isActive;

  const CommissionModel({
    required this.id,
    required this.concept,
    required this.amount,
    required this.periodicity,
    required this.isActive,
  });

  factory CommissionModel.fromJson(Map<String, dynamic> json) {
    return CommissionModel(
      id: json['id'] as int,
      concept: json['concept'] as String,
      amount: (json['amount'] as num).toDouble(),
      periodicity: json['periodicity'] as String? ?? 'MONTHLY',
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}