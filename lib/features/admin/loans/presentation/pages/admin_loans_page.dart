import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/admin_navbar.dart';
import '../../../../../injection_container.dart';
import '../../../../officer/creditos/domain/entities/loan.dart';
import '../../../../officer/creditos/presentation/bloc/creditos_cubit.dart';

class AdminLoansPage extends StatelessWidget {
  const AdminLoansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreditosCubit>()..load(),
      child: const _AdminLoansView(),
    );
  }
}

class _AdminLoansView extends StatefulWidget {
  const _AdminLoansView();

  @override
  State<_AdminLoansView> createState() => _AdminLoansViewState();
}

class _AdminLoansViewState extends State<_AdminLoansView> {
  String _activeFilter = 'PENDING_APPROVAL';

  static const _filters = [
    'PENDING_APPROVAL',
    'APPROVED',
    'REJECTED',
    'ACTIVE',
  ];

  static const _filterLabels = {
    'PENDING_APPROVAL': 'PENDING_APPROVAL',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
    'ACTIVE': 'ACTIVE',
  };

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Solicitudes de Préstamo',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Gestiona y aprueba créditos vehiculares en tiempo real.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Filtros tabs
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final f = _filters[i];
                  final active = f == _activeFilter;
                  return GestureDetector(
                    onTap: () => setState(() => _activeFilter = f),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              active ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: active
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Lista
            Expanded(
              child: BlocConsumer<CreditosCubit, CreditosState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is CreditosLoading || state is CreditosInitial) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    );
                  }
                  if (state is CreditosError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is CreditosLoaded) {
                    final filtered = state.loans
                        .where((l) => l.status == _activeFilter)
                        .toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          'No hay préstamos con estado $_activeFilter.',
                          style: const TextStyle(
                              color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () =>
                          context.read<CreditosCubit>().refresh(),
                      child: ListView.separated(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, i) => _LoanApprovalCard(
                          loan: filtered[i],
                          onRefresh: () =>
                              context.read<CreditosCubit>().refresh(),
                        ),
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
      bottomNavigationBar: const AdminNavbar(currentIndex: 1),
    );
  }
}

class _LoanApprovalCard extends StatelessWidget {
  final LoanSummary loan;
  final VoidCallback onRefresh;

  const _LoanApprovalCard({required this.loan, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info principal
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person_outline_rounded,
                      color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              loan.clientName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          _StatusBadge(status: loan.status),
                        ],
                      ),
                      Text(
                        'ID: #CDP-${loan.id}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Vehículo + monto
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'VEHÍCULO',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        loan.vehicleName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'MONTO SOLICITADO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      '\$${loan.amountFinanced.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.border),

          // Ver detalle
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: GestureDetector(
              onTap: () => context.push('/creditos/${loan.id}'),
              child: Row(
                children: const [
                  Text(
                    'Ver Detalle',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary, size: 18),
                ],
              ),
            ),
          ),

          // Botones de acción según status
          if (loan.status == 'PENDING_APPROVAL') ...[
            const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.all(12),
              child: BlocProvider(
                create: (_) => sl<LoanDetailCubit>(),
                child: _PendingActions(loan: loan, onRefresh: onRefresh),
              ),
            ),
          ],

          if (loan.status == 'APPROVED') ...[
            const Divider(height: 1, color: AppColors.border),
            Padding(
              padding: const EdgeInsets.all(12),
              child: BlocProvider(
                create: (_) => sl<LoanDetailCubit>(),
                child: _ApprovedAction(loan: loan, onRefresh: onRefresh),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PendingActions extends StatelessWidget {
  final LoanSummary loan;
  final VoidCallback onRefresh;

  const _PendingActions({required this.loan, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoanDetailCubit, LoanDetailState>(
      listener: (context, state) {
        if (state is LoanStatusUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.success,
          ));
          onRefresh();
        }
      },
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: () => _reject(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Rechazar',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: () =>
                    context.read<LoanDetailCubit>().approve(loan.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Aprobar',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _reject(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rechazar préstamo'),
        content: TextField(
          controller: ctrl,
          decoration:
              const InputDecoration(hintText: 'Motivo del rechazo...'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<LoanDetailCubit>()
                  .reject(loan.id, reason: ctrl.text);
            },
            child: const Text('Rechazar',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _ApprovedAction extends StatelessWidget {
  final LoanSummary loan;
  final VoidCallback onRefresh;

  const _ApprovedAction({required this.loan, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoanDetailCubit, LoanDetailState>(
      listener: (context, state) {
        if (state is LoanStatusUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.success,
          ));
          onRefresh();
        }
      },
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          onPressed: () => context.read<LoanDetailCubit>().activate(loan.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bolt_rounded, color: Colors.white, size: 18),
              SizedBox(width: 6),
              Text('Activar Crédito',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final cfg = _cfg(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cfg.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        cfg.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: cfg.color,
        ),
      ),
    );
  }

  _BadgeCfg _cfg(String s) {
    switch (s) {
      case 'PENDING_APPROVAL':
        return _BadgeCfg(
            'PENDIENTE', AppColors.warning, AppColors.warningLight);
      case 'APPROVED':
        return _BadgeCfg(
            'APROBADO', AppColors.success, AppColors.successLight);
      case 'REJECTED':
        return _BadgeCfg('RECHAZADO', AppColors.error, AppColors.errorLight);
      case 'ACTIVE':
        return _BadgeCfg('ACTIVO', AppColors.primary, AppColors.primaryLight);
      default:
        return _BadgeCfg(s, AppColors.textSecondary, AppColors.border);
    }
  }
}

class _BadgeCfg {
  final String label;
  final Color color;
  final Color bg;
  _BadgeCfg(this.label, this.color, this.bg);
}