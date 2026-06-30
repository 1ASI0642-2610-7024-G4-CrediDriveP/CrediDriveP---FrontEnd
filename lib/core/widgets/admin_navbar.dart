import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../navigation/app_router.dart';
import '../theme/app_colors.dart';

class AdminNavbar extends StatelessWidget {
  final int currentIndex;
  const AdminNavbar({super.key, required this.currentIndex});

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
                icon: Icons.grid_view_rounded,
                iconActive: Icons.grid_view_rounded,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => context.go(AppRoutes.adminHome),
              ),
              _NavItem(
                icon: Icons.assignment_outlined,
                iconActive: Icons.assignment_rounded,
                label: 'Solicitudes',
                isActive: currentIndex == 1,
                onTap: () => context.go(AppRoutes.adminLoans),
              ),
              _NavItem(
                icon: Icons.shield_outlined,
                iconActive: Icons.shield_rounded,
                label: 'Seguros',
                isActive: currentIndex == 2,
                onTap: () => context.go(AppRoutes.adminInsurances),
              ),
              
              _NavItem(
                icon: Icons.payments_outlined,
                iconActive: Icons.payments_rounded,
                label: 'Comisiones',
                isActive: currentIndex == 3,
                onTap: () => context.go(AppRoutes.adminCommissions),
              ),
              _NavItem(
                icon: Icons.credit_card_outlined,
                iconActive: Icons.credit_card_rounded,
                label: 'Planes',
                isActive: currentIndex == 4,
                onTap: () => context.go(AppRoutes.adminLoanPlans),
              ),
              _NavItem(
                icon: Icons.badge_outlined,
                iconActive: Icons.badge_rounded,
                label: 'Officers',
                isActive: currentIndex == 5,
                onTap: () => context.go(AppRoutes.adminOfficers),
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
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              Container(
                width: 44,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(iconActive, color: Colors.white, size: 18),
              )
            else
              Icon(icon, color: AppColors.navbarInactive, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
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