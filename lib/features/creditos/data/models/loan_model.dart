import '../../domain/entities/loan.dart';

class LoanIndicatorsModel extends LoanIndicators {
  const LoanIndicatorsModel({
    required super.van,
    required super.tirMonthly,
    required super.tirAnnual,
    required super.tcea,
  });

  factory LoanIndicatorsModel.fromJson(Map<String, dynamic> json) {
    return LoanIndicatorsModel(
      van: (json['van'] as num).toDouble(),
      tirMonthly: (json['tirMonthly'] as num).toDouble(),
      tirAnnual: (json['tirAnnual'] as num).toDouble(),
      tcea: (json['tcea'] as num).toDouble(),
    );
  }
}

class LoanScheduleRowModel extends LoanScheduleRow {
  const LoanScheduleRowModel({
    required super.periodNumber,
    required super.openingBalance,
    required super.interest,
    required super.principal,
    required super.insuranceDesgravamen,
    required super.insuranceVehicular,
    required super.commission,
    required super.totalPayment,
    required super.closingBalance,
  });

  factory LoanScheduleRowModel.fromJson(Map<String, dynamic> json) {
    return LoanScheduleRowModel(
      periodNumber: json['periodNumber'] as int,
      openingBalance: (json['openingBalance'] as num).toDouble(),
      interest: (json['interest'] as num).toDouble(),
      principal: (json['principal'] as num).toDouble(),
      insuranceDesgravamen:
          (json['insuranceDesgravamen'] as num? ?? 0).toDouble(),
      insuranceVehicular:
          (json['insuranceVehicular'] as num? ?? 0).toDouble(),
      commission: (json['commission'] as num? ?? 0).toDouble(),
      totalPayment: (json['totalPayment'] as num).toDouble(),
      closingBalance: (json['closingBalance'] as num).toDouble(),
    );
  }
}

class LoanSummaryModel extends LoanSummary {
  const LoanSummaryModel({
    required super.id,
    required super.clientName,
    required super.vehicleName,
    required super.currency,
    required super.totalPayment,
    required super.status,
    required super.termMonths,
    required super.amountFinanced,
  });

  factory LoanSummaryModel.fromJson(Map<String, dynamic> json) {
    // El backend puede traer client y vehicle anidados o como strings
    final clientName = json['clientName'] as String? ??
        json['client']?['fullName'] as String? ?? 'Sin cliente';
    final vehicleName = json['vehicleName'] as String? ??
        (json['vehicle'] != null
            ? '${json['vehicle']['brand']} ${json['vehicle']['model']} ${json['vehicle']['year']}'
            : 'Sin vehículo');

    return LoanSummaryModel(
      id: json['id'] as int,
      clientName: clientName,
      vehicleName: vehicleName,
      currency: json['currency'] as String? ?? 'PEN',
      totalPayment: (json['monthlyPayment'] as num? ?? 0).toDouble(),
      status: json['status'] as String? ?? 'PENDING_APPROVAL',
      termMonths: json['termMonths'] as int? ?? 0,
      amountFinanced: (json['amountFinanced'] as num? ?? 0).toDouble(),
    );
  }
}

class LoanModel extends Loan {
  const LoanModel({
    required super.id,
    required super.clientName,
    required super.vehicleName,
    required super.currency,
    required super.amountFinanced,
    required super.termMonths,
    required super.interestRate,
    required super.rateType,
    required super.status,
    required super.indicators,
    required super.schedule,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    final clientName = json['clientName'] as String? ??
        json['client']?['fullName'] as String? ?? 'Sin cliente';
    final vehicleName = json['vehicleName'] as String? ??
        (json['vehicle'] != null
            ? '${json['vehicle']['brand']} ${json['vehicle']['model']} ${json['vehicle']['year']}'
            : 'Sin vehículo');

    return LoanModel(
      id: json['id'] as int,
      clientName: clientName,
      vehicleName: vehicleName,
      currency: json['currency'] as String? ?? 'PEN',
      amountFinanced: (json['amountFinanced'] as num).toDouble(),
      termMonths: json['termMonths'] as int? ?? 0,
      interestRate: (json['interestRate'] as num? ?? 0).toDouble(),
      rateType: json['rateType'] as String? ?? 'TEA',
      status: json['status'] as String? ?? 'PENDING_APPROVAL',
      indicators: LoanIndicatorsModel.fromJson(
          json['indicators'] as Map<String, dynamic>),
      schedule: (json['schedule'] as List<dynamic>)
          .map((e) => LoanScheduleRowModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}