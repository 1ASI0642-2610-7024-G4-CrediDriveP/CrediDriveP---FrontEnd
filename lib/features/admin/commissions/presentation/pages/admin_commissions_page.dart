import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/api/dio_client.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/admin_navbar.dart';
import '../../../../../injection_container.dart';
import '../../data/datasources/commissions_datasource.dart';
import '../../data/models/commission_model.dart';
import '../bloc/commissions_cubit.dart';

class AdminCommissionsPage extends StatelessWidget {
  const AdminCommissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CommissionsCubit(
        CommissionsDatasourceImpl(sl<DioClient>().dio),
      )..load(),
      child: const _CommissionsView(),
    );
  }
}

class _CommissionsView extends StatelessWidget {
  const _CommissionsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<CommissionsCubit, CommissionsState>(
          listener: (context, state) {
            if (state is CommissionMutationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ));
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Configuración de Comisiones',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Gestiona los conceptos y montos de las comisiones del sistema.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Botón crear
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => _showForm(context),
                        icon: const Icon(Icons.add_rounded, size: 20),
                        label: const Text('+ Crear Comisión',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Stats rápidas
                if (state is CommissionsLoaded) ...[
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          _QuickStat(
                            icon: Icons.receipt_long_rounded,
                            iconColor: AppColors.primary,
                            iconBg: AppColors.primaryLight,
                            label: 'TOTAL ACTIVAS',
                            value:
                                '${state.commissions.where((c) => c.isActive).length} Conceptos',
                          ),
                          const SizedBox(height: 10),
                          _QuickStat(
                            icon: Icons.repeat_rounded,
                            iconColor: AppColors.success,
                            iconBg: AppColors.successLight,
                            label: 'MENSUALES',
                            value:
                                '${state.commissions.where((c) => c.periodicity == 'MONTHLY').length} Recurrentes',
                          ),
                          const SizedBox(height: 10),
                          _QuickStat(
                            icon: Icons.history_rounded,
                            iconColor: AppColors.error,
                            iconBg: AppColors.errorLight,
                            label: 'ÚLTIMO CAMBIO',
                            value: 'Hace 2 días',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // Lista de comisiones
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CommissionCard(
                            commission: state.commissions[i],
                          ),
                        ),
                        childCount: state.commissions.length,
                      ),
                    ),
                  ),
                ],

                if (state is CommissionsLoading ||
                    state is CommissionsInitial)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                            color: AppColors.primary),
                      ),
                    ),
                  ),

                // Banner ayuda
                SliverPadding(
                  padding:
                      const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              color: Colors.white, size: 28),
                          const SizedBox(height: 10),
                          const Text(
                            '¿Necesitas ayuda con las reglas?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Las comisiones configuradas aquí se aplicarán automáticamente a todos los nuevos contratos generados a partir de la fecha de activación.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding:
                                const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                'Ver Tutorial',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const AdminNavbar(currentIndex: 3),
    );
  }

  void _showForm(BuildContext context, [CommissionModel? comm]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<CommissionsCubit>(),
        child: _CommissionFormSheet(commission: comm),
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;

  const _QuickStat({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
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

class _CommissionCard extends StatelessWidget {
  final CommissionModel commission;
  const _CommissionCard({required this.commission});

  @override
  Widget build(BuildContext context) {
    final periodicityColor = commission.periodicity == 'MONTHLY'
        ? AppColors.primary
        : commission.periodicity == 'ONE_TIME'
            ? const Color(0xFF8B5CF6)
            : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: commission.isActive ? AppColors.surface : AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.receipt_long_rounded,
                    color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commission.concept,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: periodicityColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            commission.periodicity,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: periodicityColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: commission.isActive
                                ? AppColors.successLight
                                : AppColors.border,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            commission.isActive ? 'ACTIVO' : 'INACTIVO',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: commission.isActive
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$${commission.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: commission.isActive
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => BlocProvider.value(
                    value: context.read<CommissionsCubit>(),
                    child: _CommissionFormSheet(commission: commission),
                  ),
                ),
                child: const Icon(Icons.edit_outlined,
                    color: AppColors.textSecondary, size: 20),
              ),
              const Spacer(),
              Switch(
                value: commission.isActive,
                activeColor: AppColors.primary,
                onChanged: (_) => context
                    .read<CommissionsCubit>()
                    .toggle(commission.id),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommissionFormSheet extends StatefulWidget {
  final CommissionModel? commission;
  const _CommissionFormSheet({this.commission});

  @override
  State<_CommissionFormSheet> createState() => _CommissionFormSheetState();
}

class _CommissionFormSheetState extends State<_CommissionFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _concept;
  late final TextEditingController _amount;
  String _periodicity = 'MONTHLY';

  bool get _isEdit => widget.commission != null;

  @override
  void initState() {
    super.initState();
    final c = widget.commission;
    _concept = TextEditingController(text: c?.concept ?? '');
    _amount = TextEditingController(
        text: c != null ? c.amount.toStringAsFixed(2) : '');
    if (c != null) _periodicity = c.periodicity;
  }

  @override
  void dispose() {
    _concept.dispose();
    _amount.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'concept': _concept.text.trim(),
      'amount': double.parse(_amount.text.trim()),
      'periodicity': _periodicity,
    };
    if (_isEdit) {
      context.read<CommissionsCubit>().update(widget.commission!.id, data);
    } else {
      context.read<CommissionsCubit>().create(data);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isEdit ? 'Editar Comisión' : 'Nueva Comisión',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),

              _label('CONCEPTO'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _concept,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Requerido.' : null,
                decoration: const InputDecoration(
                    hintText: 'Gastos Administrativos'),
              ),
              const SizedBox(height: 14),

              _label('MONTO (S/ o \$)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amount,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Requerido.' : null,
                decoration: const InputDecoration(hintText: '45.00'),
              ),
              const SizedBox(height: 14),

              _label('PERIODICIDAD'),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _periodicity,
                    isExpanded: true,
                    dropdownColor: AppColors.surface,
                    items: ['MONTHLY', 'ONE_TIME', 'ANNUAL']
                        .map((o) =>
                            DropdownMenuItem(value: o, child: Text(o)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _periodicity = v);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                      _isEdit ? 'Guardar cambios' : 'Crear comisión'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 11, fontWeight: FontWeight.w700,
          color: AppColors.textSecondary, letterSpacing: 0.5,
        ),
      );
}