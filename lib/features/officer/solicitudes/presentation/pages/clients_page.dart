import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_navbar.dart';
import '../../../../../injection_container.dart';
import '../bloc/clients_cubit.dart';
import '../widgets/client_card.dart';
import '../widgets/client_form_sheet.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ClientsCubit>()..load(),
      child: const _ClientsView(),
    );
  }
}

class _ClientsView extends StatelessWidget {
  const _ClientsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 20, color: AppColors.textPrimary),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Gestión de Clientes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Buscador
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SearchBar(),
            ),

            const SizedBox(height: 16),

            // Lista
            Expanded(
              child: BlocConsumer<ClientsCubit, ClientsState>(
                listener: (context, state) {
                  if (state is ClientMutationSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                  if (state is ClientMutationError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ClientsLoading || state is ClientsInitial) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }
                  if (state is ClientsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              color: AppColors.textHint, size: 48),
                          const SizedBox(height: 12),
                          Text(state.message,
                              style: const TextStyle(
                                  color: AppColors.textSecondary)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<ClientsCubit>().load(),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is ClientsLoaded) {
                    if (state.filtered.isEmpty) {
                      return const Center(
                        child: Text('No se encontraron clientes.',
                            style:
                                TextStyle(color: AppColors.textSecondary)),
                      );
                    }
                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () => context.read<ClientsCubit>().load(),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: state.filtered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final client = state.filtered[i];
                          return ClientCard(
                            client: client,
                            onEdit: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => BlocProvider.value(
                                value: context.read<ClientsCubit>(),
                                child: ClientFormSheet(client: client),
                              ),
                            ),
                            onDelete: () => _confirmDelete(context, client.id),
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
      floatingActionButton: _AddFab(),
      bottomNavigationBar: const AppNavbar(currentIndex: 1),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar cliente'),
        content: const Text('¿Estás seguro? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ClientsCubit>().delete(id);
            },
            child: const Text('Eliminar',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (v) => context.read<ClientsCubit>().search(v),
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Buscar por nombre o DNI...',
        prefixIcon: const Icon(Icons.search_rounded,
            color: AppColors.textSecondary, size: 20),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

class _AddFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      onPressed: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => BlocProvider.value(
          value: context.read<ClientsCubit>(),
          child: const ClientFormSheet(),
        ),
      ),
      child: const Icon(Icons.person_add_rounded, color: Colors.white),
    );
  }
}