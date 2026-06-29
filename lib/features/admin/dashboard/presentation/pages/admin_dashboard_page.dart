import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/navigation/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/admin_navbar.dart';
import '../../../../../injection_container.dart';
// Reutiliza el mismo HomeCubit del officer — mismo endpoint
import '../../../../officer/home/presentation/bloc/home_cubit.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>()..load(),
      child: const _AdminDashboardView(),
    );
  }
}

class _AdminDashboardView extends StatelessWidget {
  const _AdminDashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      children: [
                        const Icon(Icons.menu_rounded,
                            color: AppColors.textPrimary, size: 26),
                        const SizedBox(width: 12),
                        const Text(
                          'CrediDriveP',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                        onTap: () => context.go(AppRoutes.configuracion),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border, width: 2),
                            ),
                            child: const Icon(Icons.person_rounded,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Dashboard Global',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Resumen operacional del sistema CrediDriveP.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                // Stat cards
                if (state is HomeLoaded) ...[
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          _StatRow(
                            icon: Icons.people_alt_rounded,
                            iconColor: AppColors.primary,
                            iconBg: AppColors.primaryLight,
                            label: 'TOTAL CLIENTS',
                            value: state.summary.totalClients
                                .toString()
                                .replaceAllMapped(
                                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                    (m) => '${m[1]},'),
                          ),
                          const SizedBox(height: 12),
                          _StatRow(
                            icon: Icons.directions_car_rounded,
                            iconColor: AppColors.success,
                            iconBg: AppColors.successLight,
                            label: 'TOTAL VEHICLES',
                            value: state.summary.totalVehicles.toString(),
                          ),
                          const SizedBox(height: 12),
                          _StatRow(
                            icon: Icons.bar_chart_rounded,
                            iconColor: const Color(0xFF8B5CF6),
                            iconBg: const Color(0xFFEDE9FE),
                            label: 'TOTAL SIMULATIONS',
                            value: state.summary.totalSimulations
                                .toString()
                                .replaceAllMapped(
                                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                    (m) => '${m[1]},'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // Banner préstamos pendientes
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: _PendingBanner(
                        count: state.summary.pendingLoans,
                        onTap: () => context.go(AppRoutes.adminLoans),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Actividad reciente
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Actividad reciente de todo el sistema',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Icon(Icons.tune_rounded,
                              color: AppColors.textSecondary, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final a = state.summary.recentActivity[i];
                          return _ActivityCard(activity: a);
                        },
                        childCount: state.summary.recentActivity.length,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 12)),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'VER TODA LA ACTIVIDAD',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                if (state is HomeLoading)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                            color: AppColors.primary),
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const AdminNavbar(currentIndex: 0),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PendingBanner extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _PendingBanner({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.pending_actions_rounded,
                  color: Colors.white, size: 22),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Préstamos pendientes de aprobación',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Hay $count nuevas solicitudes esperando tu revisión hoy.',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Revisar solicitudes',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded,
                      color: AppColors.primary, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final dynamic activity;
  const _ActivityCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    final cfg = _cfg(activity.type as String);
    final diff =
        DateTime.now().difference(activity.createdAt as DateTime);
    final time = diff.inMinutes < 60
        ? 'Hace ${diff.inMinutes}m'
        : diff.inHours < 24
            ? 'Hace ${diff.inHours}h'
            : 'Hace ${diff.inDays}d';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cfg.bg,
              shape: BoxShape.circle,
            ),
            child: Icon(cfg.icon, color: cfg.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.description as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity.description as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  _Cfg _cfg(String type) {
    switch (type) {
      case 'CLIENT':
        return _Cfg(Icons.person_add_alt_rounded, AppColors.primary,
            AppColors.primaryLight);
      case 'SIMULATION':
        return _Cfg(Icons.calculate_rounded, const Color(0xFF8B5CF6),
            const Color(0xFFEDE9FE));
      case 'LOAN':
        return _Cfg(Icons.credit_card_rounded, AppColors.success,
            AppColors.successLight);
      case 'VEHICLE':
        return _Cfg(Icons.add_circle_rounded, AppColors.success,
            AppColors.successLight);
      default:
        return _Cfg(Icons.info_outline_rounded, AppColors.textSecondary,
            AppColors.border);
    }
  }
}

class _Cfg {
  final IconData icon;
  final Color color;
  final Color bg;
  _Cfg(this.icon, this.color, this.bg);
}