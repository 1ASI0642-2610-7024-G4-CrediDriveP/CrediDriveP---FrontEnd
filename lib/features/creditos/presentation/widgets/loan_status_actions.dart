import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/loan.dart';
import '../bloc/creditos_cubit.dart';

/// Muestra botones de acción según el estado actual del préstamo.
/// Solo visible para ADMIN — en producción filtrar por rol.
class LoanStatusActions extends StatelessWidget {
  final Loan loan;
  const LoanStatusActions({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    // Flujo: PENDING_APPROVAL → APPROVED / REJECTED
    //        APPROVED → ACTIVE
    //        ACTIVE → PAID / CANCELLED
    switch (loan.status) {
      case 'PENDING_APPROVAL':
        return Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: 'Aprobar',
                icon: Icons.check_circle_outline_rounded,
                color: AppColors.success,
                onTap: () => _confirm(
                  context,
                  title: 'Aprobar préstamo',
                  message: '¿Confirmas la aprobación de este préstamo?',
                  onConfirm: (reason) =>
                      context.read<LoanDetailCubit>().approve(loan.id, reason: reason),
                  withReason: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                label: 'Rechazar',
                icon: Icons.cancel_outlined,
                color: AppColors.error,
                onTap: () => _confirm(
                  context,
                  title: 'Rechazar préstamo',
                  message: 'Indica el motivo del rechazo.',
                  onConfirm: (reason) =>
                      context.read<LoanDetailCubit>().reject(loan.id, reason: reason),
                  withReason: true,
                ),
              ),
            ),
          ],
        );
      case 'APPROVED':
        return _ActionButton(
          label: 'Activar préstamo',
          icon: Icons.play_circle_outline_rounded,
          color: AppColors.primary,
          onTap: () => _confirm(
            context,
            title: 'Activar préstamo',
            message: '¿Confirmas la activación?',
            onConfirm: (_) =>
                context.read<LoanDetailCubit>().activate(loan.id),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required void Function(String? reason) onConfirm,
    bool withReason = false,
  }) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            if (withReason) ...[
              const SizedBox(height: 16),
              TextField(
                controller: reasonCtrl,
                decoration: const InputDecoration(
                  hintText: 'Motivo (opcional)',
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm(
                  reasonCtrl.text.trim().isEmpty ? null : reasonCtrl.text.trim());
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}