import '../../domain/entities/simulation.dart';

class SimulationIndicatorsModel extends SimulationIndicators {
  const SimulationIndicatorsModel({
    required super.van,
    required super.tirMonthly,
    required super.tirAnnual,
    required super.tcea,
    required super.cokUsed,
  });

  factory SimulationIndicatorsModel.fromJson(Map<String, dynamic> json) {
    return SimulationIndicatorsModel(
      van: (json['van'] as num).toDouble(),
      tirMonthly: (json['tirMonthly'] as num).toDouble(),
      tirAnnual: (json['tirAnnual'] as num).toDouble(),
      tcea: (json['tcea'] as num).toDouble(),
      cokUsed: (json['cokUsed'] as num).toDouble(),
    );
  }
}

class ScheduleRowModel extends ScheduleRow {
  const ScheduleRowModel({
    required super.periodNumber,
    required super.openingBalance,
    required super.interest,
    required super.principal,
    required super.insuranceDesgravamen,
    required super.insuranceVehicular,
    required super.commission,
    required super.balloon,
    required super.totalPayment,
    required super.closingBalance,
  });

  factory ScheduleRowModel.fromJson(Map<String, dynamic> json) {
    return ScheduleRowModel(
      periodNumber: json['periodNumber'] as int,
      openingBalance: (json['openingBalance'] as num).toDouble(),
      interest: (json['interest'] as num).toDouble(),
      principal: (json['principal'] as num).toDouble(),
      insuranceDesgravamen:
          (json['insuranceDesgravamen'] as num? ?? 0).toDouble(),
      insuranceVehicular:
          (json['insuranceVehicular'] as num? ?? 0).toDouble(),
      commission: (json['commission'] as num? ?? 0).toDouble(),
      balloon: (json['balloon'] as num? ?? 0).toDouble(),
      totalPayment: (json['totalPayment'] as num).toDouble(),
      closingBalance: (json['closingBalance'] as num).toDouble(),
    );
  }
}

class SimulationModel extends Simulation {
  const SimulationModel({
    required super.id,
    required super.name,
    required super.status,
    required super.amountFinanced,
    required super.currency,
    required super.termMonths,
    required super.interestRate,
    required super.rateType,
    required super.indicators,
    required super.schedule,
  });

  factory SimulationModel.fromJson(Map<String, dynamic> json) {
    return SimulationModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String? ?? 'SAVED',
      amountFinanced: (json['amountFinanced'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'PEN',
      termMonths: json['termMonths'] as int? ?? 0,
      interestRate: (json['interestRate'] as num? ?? 0).toDouble(),
      rateType: json['rateType'] as String? ?? 'TEA',
      indicators: SimulationIndicatorsModel.fromJson(
          json['indicators'] as Map<String, dynamic>),
      schedule: (json['schedule'] as List<dynamic>)
          .map((e) => ScheduleRowModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SimulationSummaryModel extends SimulationSummary {
  const SimulationSummaryModel({
    required super.id,
    required super.name,
    required super.status,
    required super.amountFinanced,
    required super.currency,
    required super.termMonths,
    super.tcea,
  });

  factory SimulationSummaryModel.fromJson(Map<String, dynamic> json) {
    return SimulationSummaryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String? ?? 'SAVED',
      amountFinanced: (json['amountFinanced'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'PEN',
      termMonths: json['termMonths'] as int? ?? 0,
      tcea: json['tcea'] != null ? (json['tcea'] as num).toDouble() : null,
    );
  }
}