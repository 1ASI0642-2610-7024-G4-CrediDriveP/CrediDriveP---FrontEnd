import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class QuickAccessButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const QuickAccessButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: isPrimary ? null : Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isPrimary ? Colors.white : AppColors.primary,
              size: 22,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isPrimary ? Colors.white : AppColors.primary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              color: isPrimary ? Colors.white : AppColors.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}