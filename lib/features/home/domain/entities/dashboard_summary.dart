import 'package:equatable/equatable.dart';

class DashboardSummary extends Equatable {
  final int totalClients;
  final int totalVehicles;
  final int totalSimulations;
  final int pendingLoans;
  final int approvedLoans;
  final List<RecentActivity> recentActivity;

  const DashboardSummary({
    required this.totalClients,
    required this.totalVehicles,
    required this.totalSimulations,
    required this.pendingLoans,
    required this.approvedLoans,
    required this.recentActivity,
  });

  @override
  List<Object> get props => [
        totalClients,
        totalVehicles,
        totalSimulations,
        pendingLoans,
        approvedLoans,
        recentActivity,
      ];
}

class RecentActivity extends Equatable {
  final String type; // 'CLIENT' | 'SIMULATION' | 'LOAN' | 'VEHICLE'
  final String description;
  final DateTime createdAt;

  const RecentActivity({
    required this.type,
    required this.description,
    required this.createdAt,
  });

  @override
  List<Object> get props => [type, description, createdAt];
}