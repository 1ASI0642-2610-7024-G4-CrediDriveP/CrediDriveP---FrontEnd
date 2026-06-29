import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/loan.dart';

class LoanCard extends StatelessWidget {
  final LoanSummary loan;
  final VoidCallback onTap;

  const LoanCard({super.key, required this.loan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusCfg = _statusConfig(loan.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Ícono
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.directions_car_rounded,
                color: AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loan.vehicleName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    loan.clientName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '${loan.currency} ${loan.totalPayment.toStringAsFixed(2)} / mes',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusCfg.bg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statusCfg.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: statusCfg.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }

  _StatusCfg _statusConfig(String status) {
    switch (status) {
      case 'APPROVED':
        return _StatusCfg('APROBADO', AppColors.success, AppColors.successLight);
      case 'ACTIVE':
        return _StatusCfg('ACTIVO', AppColors.success, AppColors.successLight);
      case 'PENDING_APPROVAL':
        return _StatusCfg('PENDIENTE', AppColors.warning, AppColors.warningLight);
      case 'REJECTED':
        return _StatusCfg('RECHAZADO', AppColors.error, AppColors.errorLight);
      case 'PAID':
        return _StatusCfg('PAGADO', AppColors.primary, AppColors.primaryLight);
      case 'CANCELLED':
        return _StatusCfg('CANCELADO', AppColors.textSecondary, AppColors.border);
      default:
        return _StatusCfg(status, AppColors.textSecondary, AppColors.border);
    }
  }
}

class _StatusCfg {
  final String label;
  final Color color;
  final Color bg;
  _StatusCfg(this.label, this.color, this.bg);
}