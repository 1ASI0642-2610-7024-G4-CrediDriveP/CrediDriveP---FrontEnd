import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_navbar.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../injection_container.dart';
import '../bloc/home_cubit.dart';
import '../widgets/activity_item.dart';
import '../widgets/quick_access_button.dart';
import '../widgets/stat_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>()..load(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const HomeSkeleton();
            }
            if (state is HomeError) {
              return _ErrorView(
                message: state.message,
                onRetry: () => context.read<HomeCubit>().refresh(),
              );
            }
            if (state is HomeLoaded) {
              return _LoadedView(state: state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: const AppNavbar(currentIndex: 0),
    );
  }
}

class _LoadedView extends StatelessWidget {
  final HomeLoaded state;
  const _LoadedView({required this.state});

  @override
  Widget build(BuildContext context) {
    final s = state.summary;
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => context.read<HomeCubit>().refresh(),
      child: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola, ${state.userName}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Aquí tienes el resumen de hoy en CrediDrive.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.configuracion),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: AppColors.textSecondary,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Stat cards 2 columnas
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
              ),
              delegate: SliverChildListDelegate([
                StatCard(
                  icon: Icons.people_alt_rounded,
                  label: 'CLIENTES',
                  value: s.totalClients.toString(),
                ),
                StatCard(
                  icon: Icons.directions_car_rounded,
                  label: 'VEHÍCULOS',
                  value: s.totalVehicles.toString(),
                  iconBgColor: const Color(0xFFDCFCE7),
                  iconColor: AppColors.success,
                ),
              ]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Stat card ancha — Simulaciones
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: StatCard(
                icon: Icons.bar_chart_rounded,
                label: 'SIMULACIONES',
                value: s.totalSimulations.toString(),
                iconBgColor: const Color(0xFFEDE9FE),
                iconColor: const Color(0xFF8B5CF6),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 28)),

          // Actividad reciente
          if (s.recentActivity.isNotEmpty) ...[
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'ACTIVIDAD RECIENTE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: s.recentActivity
                        .take(5)
                        .map((a) => ActivityItem(activity: a))
                        .toList(),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
          ],

          // Accesos rápidos
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Text(
                'ACCESOS RÁPIDOS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  QuickAccessButton(
                    label: 'Nueva Simulación',
                    icon: Icons.add_circle_outline_rounded,
                    isPrimary: true,
                    onTap: () => context.go(AppRoutes.simular),
                  ),
                  const SizedBox(height: 10),
                  QuickAccessButton(
                    label: 'Ver Clientes',
                    icon: Icons.people_alt_outlined,
                    onTap: () => context.go(AppRoutes.solicitudesClientes),
                  ),
                  const SizedBox(height: 10),
                  QuickAccessButton(
                    label: 'Catálogo de Vehículos',
                    icon: Icons.directions_car_outlined,
                    onTap: () => context.go(AppRoutes.solicitudesVehiculos),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 56, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}