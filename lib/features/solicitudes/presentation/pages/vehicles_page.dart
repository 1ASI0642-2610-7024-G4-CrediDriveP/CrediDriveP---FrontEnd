import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_navbar.dart';
import '../../../../injection_container.dart';
import '../bloc/vehicles_cubit.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/vehicle_form_sheet.dart';

class VehiclesPage extends StatelessWidget {
  const VehiclesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VehiclesCubit>()..load(),
      child: const _VehiclesView(),
    );
  }
}

class _VehiclesView extends StatelessWidget {
  const _VehiclesView();

  static const _filters = ['Todos', 'Disponibles', 'SUV', 'Camionetas'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header + búsqueda
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 20, color: AppColors.textPrimary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      onChanged: (v) =>
                          context.read<VehiclesCubit>().search(v),
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Buscar vehículo...',
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: AppColors.textSecondary, size: 20),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Filtros horizontales
            BlocBuilder<VehiclesCubit, VehiclesState>(
              builder: (context, state) {
                final active = state is VehiclesLoaded
                    ? state.activeFilter
                    : 'Todos';
                return SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final f = _filters[i];
                      final isActive = f == active;
                      return GestureDetector(
                        onTap: () =>
                            context.read<VehiclesCubit>().filter(f),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isActive
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(
                            f,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Lista
            Expanded(
              child: BlocConsumer<VehiclesCubit, VehiclesState>(
                listener: (context, state) {
                  if (state is VehicleMutationSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.success,
                    ));
                  }
                  if (state is VehicleMutationError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ));
                  }
                },
                builder: (context, state) {
                  if (state is VehiclesLoading || state is VehiclesInitial) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    );
                  }
                  if (state is VehiclesError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is VehiclesLoaded) {
                    if (state.filtered.isEmpty) {
                      return const Center(
                        child: Text('No hay vehículos.',
                            style:
                                TextStyle(color: AppColors.textSecondary)),
                      );
                    }
                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () =>
                          context.read<VehiclesCubit>().load(),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: state.filtered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, i) {
                          final v = state.filtered[i];
                          return VehicleCard(
                            vehicle: v,
                            onEdit: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => BlocProvider.value(
                                value: context.read<VehiclesCubit>(),
                                child: VehicleFormSheet(vehicle: v),
                              ),
                            ),
                            onDelete: () => context
                                .read<VehiclesCubit>()
                                .delete(v.id),
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => BlocProvider.value(
            value: context.read<VehiclesCubit>(),
            child: const VehicleFormSheet(),
          ),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      bottomNavigationBar: const AppNavbar(currentIndex: 1),
    );
  }
}