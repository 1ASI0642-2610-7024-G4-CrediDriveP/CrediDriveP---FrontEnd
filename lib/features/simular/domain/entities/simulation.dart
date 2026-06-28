import 'package:equatable/equatable.dart';

class SimulationIndicators extends Equatable {
  final double van;
  final double tirMonthly;
  final double tirAnnual;
  final double tcea;
  final double cokUsed;

  const SimulationIndicators({
    required this.van,
    required this.tirMonthly,
    required this.tirAnnual,
    required this.tcea,
    required this.cokUsed,
  });

  @override
  List<Object> get props => [van, tcea];
}

class ScheduleRow extends Equatable {
  final int periodNumber;
  final double openingBalance;
  final double interest;
  final double principal;
  final double insuranceDesgravamen;
  final double insuranceVehicular;
  final double commission;
  final double balloon;
  final double totalPayment;
  final double closingBalance;

  const ScheduleRow({
    required this.periodNumber,
    required this.openingBalance,
    required this.interest,
    required this.principal,
    required this.insuranceDesgravamen,
    required this.insuranceVehicular,
    required this.commission,
    required this.balloon,
    required this.totalPayment,
    required this.closingBalance,
  });

  @override
  List<Object> get props => [periodNumber];
}

class Simulation extends Equatable {
  final int id;
  final String name;
  final String status;
  final double amountFinanced;
  final String currency;
  final int termMonths;
  final double interestRate;
  final String rateType;
  final SimulationIndicators indicators;
  final List<ScheduleRow> schedule;

  const Simulation({
    required this.id,
    required this.name,
    required this.status,
    required this.amountFinanced,
    required this.currency,
    required this.termMonths,
    required this.interestRate,
    required this.rateType,
    required this.indicators,
    required this.schedule,
  });

  @override
  List<Object> get props => [id];
}

class SimulationSummary extends Equatable {
  final int id;
  final String name;
  final String status;
  final double amountFinanced;
  final String currency;
  final int termMonths;
  final double? tcea;

  const SimulationSummary({
    required this.id,
    required this.name,
    required this.status,
    required this.amountFinanced,
    required this.currency,
    required this.termMonths,
    this.tcea,
  });

  @override
  List<Object?> get props => [id];
}