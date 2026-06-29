import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/client.dart';

class ClientCard extends StatelessWidget {
  final Client client;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ClientCard({
    super.key,
    required this.client,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                client.firstName.isNotEmpty
                    ? client.firstName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client.fullName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'DNI: ${client.dni}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _ScoreBadge(score: client.creditScore),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: client.isActive
                            ? AppColors.successLight
                            : AppColors.border,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        client.isActive ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: client.isActive
                              ? AppColors.success
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Acciones
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded,
                color: AppColors.textSecondary, size: 20),
            onSelected: (v) {
              if (v == 'edit') onEdit();
              if (v == 'delete') onDelete();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('Editar'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded,
                        size: 18, color: AppColors.error),
                    SizedBox(width: 8),
                    Text('Eliminar',
                        style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final int score;
  const _ScoreBadge({required this.score});

  @override
  Widget build(BuildContext context) {
    final color = score >= 700
        ? AppColors.success
        : score >= 500
            ? AppColors.warning
            : AppColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Score $score',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}