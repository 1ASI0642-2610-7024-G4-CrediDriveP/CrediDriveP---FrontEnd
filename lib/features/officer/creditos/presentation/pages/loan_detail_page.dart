import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_navbar.dart';
import '../../../../../injection_container.dart';
import '../../domain/entities/loan.dart';
import '../bloc/creditos_cubit.dart';
import '../widgets/loan_indicator_card.dart';
import '../widgets/loan_schedule_table.dart';
import '../widgets/loan_status_actions.dart';

class LoanDetailPage extends StatelessWidget {
  final int loanId;
  const LoanDetailPage({super.key, required this.loanId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoanDetailCubit>()..load(loanId),
      child: const _LoanDetailView(),
    );
  }
}

class _LoanDetailView extends StatelessWidget {
  const _LoanDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<LoanDetailCubit, LoanDetailState>(
          listener: (context, state) {
            if (state is LoanStatusUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ));
            }
            if (state is LoanDetailError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ));
            }
          },
          builder: (context, state) {
            if (state is LoanDetailLoading || state is LoanDetailInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is LoanDetailError) {
              return Center(child: Text(state.message));
            }
            if (state is LoanDetailLoaded ||
                state is LoanStatusUpdating ||
                state is LoanStatusUpdated) {
              final loan = state is LoanDetailLoaded
                  ? state.loan
                  : (state as dynamic).loan as Loan?;

              if (loan == null) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              return CustomScrollView(
                slivers: [
                  // Header con back
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 20,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'CrediDriveP',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // Banner resumen
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: _LoanBanner(loan: loan),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Indicadores
                  const SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        'Indicadores Financieros',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.6,
                      ),
                      delegate: SliverChildListDelegate([
                        LoanIndicatorCard(
                          icon: Icons.account_balance_rounded,
                          label: 'VAN (VNP)',
                          value:
                              '${loan.currency} ${_fmt(loan.indicators.van)}',
                          valueColor: AppColors.primary,
                        ),
                        LoanIndicatorCard(
                          icon: Icons.trending_up_rounded,
                          label: 'TIR (Retorno)',
                          value:
                              '${(loan.indicators.tirAnnual * 100).toStringAsFixed(1)}%',
                          valueColor: AppColors.success,
                        ),
                        LoanIndicatorCard(
                          icon: Icons.percent_rounded,
                          label: 'TCEA Efectiva',
                          value:
                              '${(loan.indicators.tcea * 100).toStringAsFixed(2)}%',
                          valueColor: AppColors.textPrimary,
                        ),
                        LoanIndicatorCard(
                          icon: Icons.bar_chart_rounded,
                          label: 'Interés Total',
                          value:
                              '${loan.currency} ${_fmt(loan.schedule.fold(0.0, (s, r) => s + r.interest))}',
                          valueColor: AppColors.textPrimary,
                        ),
                      ]),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Acciones de estado (solo ADMIN)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: LoanStatusActions(loan: loan),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Cronograma
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Cronograma de Pagos',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: LoanScheduleTable(
                        schedule: loan.schedule,
                        currency: loan.currency,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: const AppNavbar(currentIndex: 3),
    );
  }

  static String _fmt(double v) => v
      .toStringAsFixed(2)
      .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}

class _LoanBanner extends StatelessWidget {
  final Loan loan;
  const _LoanBanner({required this.loan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A56FF), Color(0xFF0A3ACC)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RESUMEN DE OPERACIÓN',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            loan.clientName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.directions_car_rounded,
                  color: Colors.white60, size: 14),
              const SizedBox(width: 4),
              Text(
                loan.vehicleName,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Item(
                label: 'MONTO',
                value:
                    '${loan.currency} ${loan.amountFinanced.toStringAsFixed(0)}',
              ),
              _Item(
                label: 'TASA',
                value:
                    '${(loan.interestRate * 100).toStringAsFixed(1)}% ${loan.rateType}',
              ),
              _Item(
                label: 'PLAZO',
                value: '${loan.termMonths} meses',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String label;
  final String value;
  const _Item({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white60,
                fontSize: 10,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700)),
      ],
    );
  }
}