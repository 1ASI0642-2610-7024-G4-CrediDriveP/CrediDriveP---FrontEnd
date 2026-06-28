import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_navbar.dart';
import '../../../../injection_container.dart';
import '../bloc/creditos_cubit.dart';
import '../widgets/loan_card.dart';

class CreditosPage extends StatelessWidget {
  const CreditosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreditosCubit>()..load(),
      child: const _CreditosView(),
    );
  }
}

class _CreditosView extends StatelessWidget {
  const _CreditosView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Créditos',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Historial de préstamos activos.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: BlocBuilder<CreditosCubit, CreditosState>(
                builder: (context, state) {
                  if (state is CreditosLoading || state is CreditosInitial) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    );
                  }
                  if (state is CreditosError) {
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
                                context.read<CreditosCubit>().load(),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is CreditosLoaded) {
                    if (state.loans.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay préstamos registrados.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () =>
                          context.read<CreditosCubit>().refresh(),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: state.loans.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final loan = state.loans[i];
                          return LoanCard(
                            loan: loan,
                            onTap: () => context.push(
                              '/creditos/${loan.id}',
                            ),
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
      bottomNavigationBar: const AppNavbar(currentIndex: 3),
    );
  }
}