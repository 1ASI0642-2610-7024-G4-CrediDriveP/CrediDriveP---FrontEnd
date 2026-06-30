import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/dashboard_summary.dart';

class ActivityItem extends StatelessWidget {
  final RecentActivity activity;
  const ActivityItem({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final cfg = _config(activity.type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cfg.bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(cfg.icon, color: cfg.color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _timeAgo(activity.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textHint,
            size: 20,
          ),
        ],
      ),
    );
  }

  _Cfg _config(String type) {
    switch (type) {
      case 'CLIENT':
        return _Cfg(Icons.person_add_alt_1_rounded, AppColors.primary, AppColors.primaryLight);
      case 'SIMULATION':
        return _Cfg(Icons.bar_chart_rounded, const Color(0xFF8B5CF6), const Color(0xFFEDE9FE));
      case 'LOAN':
        return _Cfg(Icons.credit_card_rounded, AppColors.success, AppColors.successLight);
      case 'VEHICLE':
        return _Cfg(Icons.directions_car_rounded, const Color(0xFFF59E0B), const Color(0xFFFEF3C7));
      default:
        return _Cfg(Icons.info_outline_rounded, AppColors.textSecondary, AppColors.border);
    }
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} minutos';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} hora${diff.inHours > 1 ? 's' : ''}';
    return 'Hace ${diff.inDays} día${diff.inDays > 1 ? 's' : ''}';
  }
}

class _Cfg {
  final IconData icon;
  final Color color;
  final Color bg;
  _Cfg(this.icon, this.color, this.bg);
}