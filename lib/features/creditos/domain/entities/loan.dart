import 'package:equatable/equatable.dart';

class LoanIndicators extends Equatable {
  final double van;
  final double tirMonthly;
  final double tirAnnual;
  final double tcea;

  const LoanIndicators({
    required this.van,
    required this.tirMonthly,
    required this.tirAnnual,
    required this.tcea,
  });

  @override
  List<Object> get props => [tcea];
}

class LoanScheduleRow extends Equatable {
  final int periodNumber;
  final double openingBalance;
  final double interest;
  final double principal;
  final double insuranceDesgravamen;
  final double insuranceVehicular;
  final double commission;
  final double totalPayment;
  final double closingBalance;

  const LoanScheduleRow({
    required this.periodNumber,
    required this.openingBalance,
    required this.interest,
    required this.principal,
    required this.insuranceDesgravamen,
    required this.insuranceVehicular,
    required this.commission,
    required this.totalPayment,
    required this.closingBalance,
  });

  @override
  List<Object> get props => [periodNumber];
}

class LoanSummary extends Equatable {
  final int id;
  final String clientName;
  final String vehicleName;
  final String currency;
  final double totalPayment; // cuota mensual
  final String status;
  final int termMonths;
  final double amountFinanced;

  const LoanSummary({
    required this.id,
    required this.clientName,
    required this.vehicleName,
    required this.currency,
    required this.totalPayment,
    required this.status,
    required this.termMonths,
    required this.amountFinanced,
  });

  @override
  List<Object> get props => [id];
}

class Loan extends Equatable {
  final int id;
  final String clientName;
  final String vehicleName;
  final String currency;
  final double amountFinanced;
  final int termMonths;
  final double interestRate;
  final String rateType;
  final String status;
  final LoanIndicators indicators;
  final List<LoanScheduleRow> schedule;

  const Loan({
    required this.id,
    required this.clientName,
    required this.vehicleName,
    required this.currency,
    required this.amountFinanced,
    required this.termMonths,
    required this.interestRate,
    required this.rateType,
    required this.status,
    required this.indicators,
    required this.schedule,
  });

  double get monthlyPayment =>
      schedule.isNotEmpty ? schedule.first.totalPayment : 0;

  @override
  List<Object> get props => [id];
}