import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../navigation/app_router.dart';
import '../theme/app_colors.dart';

class AppNavbar extends StatelessWidget {
  final int currentIndex;
  const AppNavbar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.navbarBg,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.8)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                iconActive: Icons.home_rounded,
                label: 'Inicio',
                isActive: currentIndex == 0,
                onTap: () => context.go(AppRoutes.home),
              ),
              _NavItem(
                icon: Icons.description_outlined,
                iconActive: Icons.description_rounded,
                label: 'Solicitud',
                isActive: currentIndex == 1,
                onTap: () => context.go(AppRoutes.solicitudes),
              ),
              _NavItem(
                icon: Icons.calculate_outlined,
                iconActive: Icons.calculate_rounded,
                label: 'Simular',
                isActive: currentIndex == 2,
                onTap: () => context.go(AppRoutes.simular),
              ),
              _NavItem(
                icon: Icons.credit_score_outlined,
                iconActive: Icons.credit_score_rounded,
                label: 'Créditos',
                isActive: currentIndex == 3,
                onTap: () => context.go(AppRoutes.creditos),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData iconActive;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.iconActive,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              Container(
                width: 48,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(iconActive, color: Colors.white, size: 20),
              )
            else
              Icon(icon, color: AppColors.navbarInactive, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.navbarInactive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}