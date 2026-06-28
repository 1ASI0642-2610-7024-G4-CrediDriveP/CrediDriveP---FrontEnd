import '../../domain/entities/dashboard_summary.dart';

class RecentActivityModel extends RecentActivity {
  const RecentActivityModel({
    required super.type,
    required super.description,
    required super.createdAt,
  });

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      type: json['type'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class DashboardSummaryModel extends DashboardSummary {
  const DashboardSummaryModel({
    required super.totalClients,
    required super.totalVehicles,
    required super.totalSimulations,
    required super.pendingLoans,
    required super.approvedLoans,
    required super.recentActivity,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    final activities = (json['recentActivity'] as List<dynamic>? ?? [])
        .map((e) => RecentActivityModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return DashboardSummaryModel(
      totalClients: json['totalClients'] as int? ?? 0,
      totalVehicles: json['totalVehicles'] as int? ?? 0,
      totalSimulations: json['totalSimulations'] as int? ?? 0,
      pendingLoans: json['pendingLoans'] as int? ?? 0,
      approvedLoans: json['approvedLoans'] as int? ?? 0,
      recentActivity: activities,
    );
  }
}