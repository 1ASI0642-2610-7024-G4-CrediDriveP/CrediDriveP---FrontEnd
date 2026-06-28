import 'package:flutter/material.dart' hide Simulation;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/simulation.dart';
import '../bloc/simular_cubit.dart';

class SimulationResultSheet extends StatelessWidget {
  final Simulation simulation;
  const SimulationResultSheet({super.key, required this.simulation});

  @override
  Widget build(BuildContext context) {
    final ind = simulation.indicators;
    final cur = simulation.currency;

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 4),

          Expanded(
            child: CustomScrollView(
              slivers: [
                // ── Banner resumen ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(20),
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
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          simulation.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _SummaryItem(
                              label: 'MONTO',
                              value: '$cur ${_fmt(simulation.amountFinanced)}',
                            ),
                            _SummaryItem(
                              label: 'TASA',
                              value: '${(simulation.interestRate * 100).toStringAsFixed(1)}% ${simulation.rateType}',
                            ),
                            _SummaryItem(
                              label: 'PLAZO',
                              value: '${simulation.termMonths} meses',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Indicadores financieros ─────────────────────────────
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
                      _IndicatorCard(
                        icon: Icons.account_balance_rounded,
                        label: 'VAN (VNP)',
                        value: '$cur ${_fmt(ind.van)}',
                        valueColor: AppColors.primary,
                      ),
                      _IndicatorCard(
                        icon: Icons.trending_up_rounded,
                        label: 'TIR (Retorno)',
                        value: '${(ind.tirAnnual * 100).toStringAsFixed(1)}%',
                        valueColor: AppColors.success,
                      ),
                      _IndicatorCard(
                        icon: Icons.percent_rounded,
                        label: 'TCEA Efectiva',
                        value: '${(ind.tcea * 100).toStringAsFixed(2)}%',
                        valueColor: AppColors.textPrimary,
                      ),
                      _IndicatorCard(
                        icon: Icons.bar_chart_rounded,
                        label: 'Interés Total',
                        value: '$cur ${_fmt(_totalInterest())}',
                        valueColor: AppColors.textPrimary,
                      ),
                    ]),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // ── Cronograma ─────────────────────────────────────────
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          // Header tabla
                          _TableHeader(),
                          const Divider(height: 1, color: AppColors.border),
                          // Filas
                          ...simulation.schedule.map(
                            (row) => _ScheduleRowWidget(row: row, cur: cur),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // ── Botón convertir ────────────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: BlocBuilder<SimularCubit, SimularState>(
                      builder: (context, state) {
                        final converting = state is SimularConverting;
                        return SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: converting
                                ? null
                                : () => context
                                    .read<SimularCubit>()
                                    .convertToLoan(simulation.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                            ),
                            child: converting
                                ? const SizedBox(
                                    width: 22, height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2.5))
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.send_rounded, size: 18),
                                      SizedBox(width: 8),
                                      Text('Enviar a Aprobación',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _totalInterest() =>
      simulation.schedule.fold(0.0, (sum, r) => sum + r.interest);

  static String _fmt(double v) =>
      v.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _IndicatorCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  const _IndicatorCard({
    required this.icon, required this.label,
    required this.value, required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(
                fontSize: 10, color: AppColors.textSecondary,
                fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700, color: valueColor)),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: const [
          Expanded(flex: 1, child: _TH('N° Cuota')),
          Expanded(flex: 2, child: _TH('Interés')),
          Expanded(flex: 2, child: _TH('Amortización')),
          Expanded(flex: 2, child: _TH('Total')),
        ],
      ),
    );
  }
}

class _TH extends StatelessWidget {
  final String text;
  const _TH(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
          fontSize: 11, fontWeight: FontWeight.w700,
          color: AppColors.textSecondary));
  }
}

class _ScheduleRowWidget extends StatelessWidget {
  final ScheduleRow row;
  final String cur;
  const _ScheduleRowWidget({required this.row, required this.cur});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Cuota ${row.periodNumber}',
              style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600,
                color: AppColors.textPrimary),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '$cur ${row.interest.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '$cur ${row.principal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '$cur ${row.totalPayment.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700,
                color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}