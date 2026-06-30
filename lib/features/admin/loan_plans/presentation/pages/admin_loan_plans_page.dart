import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/api/dio_client.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/admin_navbar.dart';
import '../../../../../injection_container.dart';
import '../../../../admin/insurances/data/datasources/insurances_datasource.dart';
import '../../../../admin/insurances/data/models/insurance_model.dart';
import '../../../../admin/commissions/data/datasources/commissions_datasource.dart';
import '../../../../admin/commissions/data/models/commission_model.dart';
import '../../data/datasources/loan_plans_datasource.dart';
import '../../data/models/loan_plan_model.dart';
import '../bloc/loan_plans_cubit.dart';

class AdminLoanPlansPage extends StatelessWidget {
  const AdminLoanPlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoanPlansCubit(
        LoanPlansDatasourceImpl(sl<DioClient>().dio),
      )..load(),
      child: const _LoanPlansView(),
    );
  }
}

class _LoanPlansView extends StatelessWidget {
  const _LoanPlansView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<LoanPlansCubit, LoanPlansState>(
          listener: (context, state) {
            if (state is LoanPlanMutationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ));
            }
            if (state is LoanPlansError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ));
            }
          },
          builder: (context, state) {
            final activeFilter = state is LoanPlansLoaded
                ? state.activeFilter
                : 'TODOS';

            return CustomScrollView(
              slivers: [
                // Header
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
                        const Spacer(),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_rounded,
                              color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Planes de Crédito',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Gestiona y configura los productos financieros '
                          'disponibles para los clientes.',
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

                // Botón crear + filtros
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          height: 44,
                          child: ElevatedButton.icon(
                            onPressed: () => _showForm(context),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text(
                              '+ CREAR PLAN',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        // Filtros TODOS / ACTIVOS
                        ...['TODOS', 'ACTIVOS'].map((f) {
                          final active = f == activeFilter;
                          return GestureDetector(
                            onTap: () =>
                                context.read<LoanPlansCubit>().filter(f),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: active
                                    ? AppColors.primary
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: active
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              child: Text(
                                f,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: active
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Lista
                if (state is LoanPlansLoading || state is LoanPlansInitial)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                            color: AppColors.primary),
                      ),
                    ),
                  ),

                if (state is LoanPlansLoaded && state.filtered.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final plan = state.filtered[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _PlanCard(plan: plan),
                          );
                        },
                        childCount: state.filtered.length,
                      ),
                    ),
                  ),

                if (state is LoanPlansLoaded && state.filtered.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: Center(
                        child: Text(
                          'No hay planes de crédito para mostrar.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                if (state is LoanPlansError)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: AppColors.error,
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'No se pudieron cargar los planes',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () => context.read<LoanPlansCubit>().load(),
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            );
          },
        ),
      ),
      // Usa currentIndex: 3 — reutiliza el slot de Comisiones en el navbar
      // o ajusta según decidas el orden final del navbar admin
      bottomNavigationBar: const AdminNavbar(currentIndex: 4),
    );
  }

  void _showForm(BuildContext context, [LoanPlanModel? plan]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<LoanPlansCubit>(),
        child: _LoanPlanFormSheet(plan: plan),
      ),
    );
  }
}

// ── Card de plan ──────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final LoanPlanModel plan;
  const _PlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final typeCfg = _typeConfig(plan.planType);

    return Container(
      decoration: BoxDecoration(
        color: plan.isActive ? AppColors.surface : AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge tipo + Toggle
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: typeCfg.bg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: typeCfg.color),
                      ),
                      child: Text(
                        plan.planType,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: typeCfg.color,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: plan.isActive,
                      activeColor: AppColors.primary,
                      onChanged: (_) =>
                          context.read<LoanPlansCubit>().toggle(plan.id),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Nombre del plan
                Text(
                  plan.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: plan.isActive
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),

                // Grid de datos — 2x2
                Row(
                  children: [
                    Expanded(
                      child: _DataCell(
                        label: 'MONEDA',
                        value: plan.currency == 'USD'
                            ? 'USD (\$)'
                            : 'Soles (S/)',
                      ),
                    ),
                    Expanded(
                      child: _DataCell(
                        label: 'TASA',
                        value:
                            '${plan.rateType} ${(plan.interestRate * 100).toStringAsFixed(1)}%',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _DataCell(
                        label: 'PLAZO MÁX',
                        value: '${plan.termMonths} Meses',
                      ),
                    ),
                    Expanded(
                      child: _DataCell(
                        label: 'MÉTODO',
                        value: plan.paymentMethod == 'FRENCH'
                            ? 'Francés'
                            : 'Balloon',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Seguros asociados
                if (plan.insuranceIds.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(Icons.shield_outlined,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        '${plan.insuranceIds.length} seguro(s) asociado(s)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],

                // Comisiones asociadas
                if (plan.commissionIds.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.payments_outlined,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        '${plan.commissionIds.length} comisión(es) asociada(s)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Footer — Editar
          const Divider(height: 1, color: AppColors.border),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => BlocProvider.value(
                      value: context.read<LoanPlansCubit>(),
                      child: _LoanPlanFormSheet(plan: plan),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'EDITAR',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => BlocProvider.value(
                      value: context.read<LoanPlansCubit>(),
                      child: _LoanPlanFormSheet(plan: plan),
                    ),
                  ),
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _TypeCfg _typeConfig(String type) {
    switch (type) {
      case 'PREMIUM':
        return _TypeCfg(
          const Color(0xFF7C3AED),
          const Color(0xFFEDE9FE),
        );
      case 'VANS & WORK':
        return _TypeCfg(AppColors.textSecondary, AppColors.border);
      default:
        return _TypeCfg(AppColors.primary, AppColors.primaryLight);
    }
  }
}

class _DataCell extends StatelessWidget {
  final String label;
  final String value;
  const _DataCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeCfg {
  final Color color;
  final Color bg;
  _TypeCfg(this.color, this.bg);
}

// ── Form sheet ────────────────────────────────────────────────────────────────

class _LoanPlanFormSheet extends StatefulWidget {
  final LoanPlanModel? plan;
  const _LoanPlanFormSheet({this.plan});

  @override
  State<_LoanPlanFormSheet> createState() => _LoanPlanFormSheetState();
}

class _LoanPlanFormSheetState extends State<_LoanPlanFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _interestRate;
  late final TextEditingController _termMonths;
  late final TextEditingController _graceMonths;
  late final TextEditingController _cok;

  String _currency     = 'PEN';
  String _rateType     = 'TEA';
  String _graceType    = 'NONE';
  String _paymentMethod = 'FRENCH';

  // Seguros y comisiones disponibles para asociar
  List<InsuranceModel> _insurances   = [];
  List<CommissionModel> _commissions = [];
  Set<int> _selectedInsurances   = {};
  Set<int> _selectedCommissions  = {};
  bool _loadingAssets = true;

  bool get _isEdit => widget.plan != null;
  bool get _showGrace => _graceType != 'NONE';

  @override
  void initState() {
    super.initState();
    final p = widget.plan;
    _name         = TextEditingController(text: p?.name ?? '');
    _interestRate = TextEditingController(
        text: p != null ? (p.interestRate * 100).toStringAsFixed(1) : '12');
    _termMonths   = TextEditingController(
        text: p != null ? p.termMonths.toString() : '24');
    _graceMonths  = TextEditingController(
        text: p != null ? p.graceMonths.toString() : '0');
    _cok          = TextEditingController(
        text: p != null ? (p.cokAnnual * 100).toStringAsFixed(1) : '10');

    if (p != null) {
      _currency      = p.currency;
      _rateType      = p.rateType;
      _graceType     = p.graceType;
      _paymentMethod = p.paymentMethod;
      _selectedInsurances  = Set.from(p.insuranceIds);
      _selectedCommissions = Set.from(p.commissionIds);
    }

    _loadAssets();
  }

  Future<void> _loadAssets() async {
    try {
      final ins = await InsurancesDatasourceImpl(sl<DioClient>().dio)
          .getInsurances();
      final com = await CommissionsDatasourceImpl(sl<DioClient>().dio)
          .getCommissions();
      setState(() {
        _insurances   = ins;
        _commissions  = com;
        _loadingAssets = false;
      });
    } catch (_) {
      setState(() => _loadingAssets = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _interestRate.dispose();
    _termMonths.dispose();
    _graceMonths.dispose();
    _cok.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'name'         : _name.text.trim(),
      'currency'     : _currency,
      'rateType'     : _rateType,
      'interestRate' : double.parse(_interestRate.text.trim()) / 100,
      'termMonths'   : int.parse(_termMonths.text.trim()),
      'graceType'    : _graceType,
      'graceMonths'  : _showGrace ? int.parse(_graceMonths.text.trim()) : 0,
      'paymentMethod': _paymentMethod,
      'cokAnnual'    : double.parse(_cok.text.trim()) / 100,
      'insuranceIds' : _selectedInsurances.toList(),
      'commissionIds': _selectedCommissions.toList(),
    };
    if (_isEdit) {
      context.read<LoanPlansCubit>().update(widget.plan!.id, data);
    } else {
      context.read<LoanPlansCubit>().create(data);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
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
                _isEdit ? 'Editar Plan' : 'Nuevo Plan de Crédito',
                style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Configura los parámetros del producto financiero.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),

              // ── Sección básica ──────────────────────────────────────
              _card(
                title: 'Información General',
                children: [
                  _label('NOMBRE DEL PLAN'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _name,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Requerido.' : null,
                    decoration: const InputDecoration(
                        hintText: 'Ej: Plan Estándar 24 meses'),
                  ),
                  const SizedBox(height: 16),

                  Row(children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('MONEDA'),
                        const SizedBox(height: 8),
                        _dropdown(
                          value: _currency,
                          options: const ['PEN', 'USD'],
                          labels: const ['Soles (S/)', 'USD (\$)'],
                          onChanged: (v) => setState(() => _currency = v),
                        ),
                      ],
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('TIPO TASA'),
                        const SizedBox(height: 8),
                        _dropdown(
                          value: _rateType,
                          options: const ['TEA', 'TNA'],
                          labels: const ['TEA', 'TNA'],
                          onChanged: (v) => setState(() => _rateType = v),
                        ),
                      ],
                    )),
                  ]),
                  const SizedBox(height: 16),

                  Row(children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('TASA INTERÉS (%)'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _interestRate,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Requerido.' : null,
                          decoration:
                              const InputDecoration(hintText: '12'),
                        ),
                      ],
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('PLAZO (MESES)'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _termMonths,
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Requerido.' : null,
                          decoration:
                              const InputDecoration(hintText: '24'),
                        ),
                      ],
                    )),
                  ]),
                ],
              ),

              const SizedBox(height: 16),

              // ── Sección financiera ──────────────────────────────────
              _card(
                title: 'Parámetros Financieros',
                children: [
                  Row(children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('PERIODO GRACIA'),
                        const SizedBox(height: 8),
                        _dropdown(
                          value: _graceType,
                          options: const ['NONE', 'PARTIAL', 'TOTAL'],
                          labels: const [
                            'Sin periodo', 'Parcial', 'Total'
                          ],
                          onChanged: (v) => setState(() => _graceType = v),
                        ),
                      ],
                    )),
                    if (_showGrace) ...[
                      const SizedBox(width: 12),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('MESES GRACIA'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _graceMonths,
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(hintText: '3'),
                          ),
                        ],
                      )),
                    ],
                  ]),
                  const SizedBox(height: 16),

                  Row(children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('MÉTODO DE PAGO'),
                        const SizedBox(height: 8),
                        _dropdown(
                          value: _paymentMethod,
                          options: const ['FRENCH', 'FRENCH_BALLOON'],
                          labels: const ['Francés', 'Balloon'],
                          onChanged: (v) =>
                              setState(() => _paymentMethod = v),
                        ),
                      ],
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('COK ANUAL (%)'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _cok,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Requerido.' : null,
                          decoration:
                              const InputDecoration(hintText: '10'),
                        ),
                      ],
                    )),
                  ]),
                ],
              ),

              const SizedBox(height: 16),

              // ── Seguros asociados ───────────────────────────────────
              _card(
                title: 'Seguros Asociados',
                children: [
                  if (_loadingAssets)
                    const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    )
                  else if (_insurances.isEmpty)
                    const Text(
                      'No hay seguros disponibles.',
                      style:
                          TextStyle(color: AppColors.textSecondary),
                    )
                  else
                    ..._insurances.map((ins) {
                      final selected =
                          _selectedInsurances.contains(ins.id);
                      return CheckboxListTile(
                        value: selected,
                        activeColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          ins.name,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${ins.type} — ${(ins.rate * 100).toStringAsFixed(3)}%',
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary),
                        ),
                        onChanged: (v) => setState(() {
                          if (v == true) {
                            _selectedInsurances.add(ins.id);
                          } else {
                            _selectedInsurances.remove(ins.id);
                          }
                        }),
                      );
                    }),
                ],
              ),

              const SizedBox(height: 16),

              // ── Comisiones asociadas ────────────────────────────────
              _card(
                title: 'Comisiones Asociadas',
                children: [
                  if (_loadingAssets)
                    const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    )
                  else if (_commissions.isEmpty)
                    const Text(
                      'No hay comisiones disponibles.',
                      style:
                          TextStyle(color: AppColors.textSecondary),
                    )
                  else
                    ..._commissions.map((com) {
                      final selected =
                          _selectedCommissions.contains(com.id);
                      return CheckboxListTile(
                        value: selected,
                        activeColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          com.concept,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${com.periodicity} — S/ ${com.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary),
                        ),
                        onChanged: (v) => setState(() {
                          if (v == true) {
                            _selectedCommissions.add(com.id);
                          } else {
                            _selectedCommissions.remove(com.id);
                          }
                        }),
                      );
                    }),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                    _isEdit ? 'Guardar cambios' : 'Crear plan',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      );

  Widget _dropdown({
    required String value,
    required List<String> options,
    required List<String> labels,
    required void Function(String) onChanged,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: AppColors.surface,
            items: List.generate(
              options.length,
              (i) => DropdownMenuItem(
                  value: options[i], child: Text(labels[i])),
            ),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      );
}