import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/api/dio_client.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/admin_navbar.dart';
import '../../../../../injection_container.dart';
import '../../data/datasources/insurances_datasource.dart';
import '../../data/models/insurance_model.dart';
import '../bloc/insurances_cubit.dart';

class AdminInsurancesPage extends StatelessWidget {
  const AdminInsurancesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InsurancesCubit(
        InsurancesDatasourceImpl(sl<DioClient>().dio),
      )..load(),
      child: const _InsurancesView(),
    );
  }
}

class _InsurancesView extends StatelessWidget {
  const _InsurancesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Configuración de Seguros',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Gestiona los productos de protección y tasas para el portal.',
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
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => _showForm(context),
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: const Text('+ Crear Seguro',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Buscador
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o tipo...',
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
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Lista
            BlocConsumer<InsurancesCubit, InsurancesState>(
              listener: (context, state) {
                if (state is InsuranceMutationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.success,
                  ));
                }
              },
              builder: (context, state) {
                if (state is InsurancesLoading || state is InsurancesInitial) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                            color: AppColors.primary),
                      ),
                    ),
                  );
                }
                if (state is InsurancesLoaded) {
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _InsuranceCard(
                            insurance: state.insurances[i],
                          ),
                        ),
                        childCount: state.insurances.length,
                      ),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),

            // Banner ayuda
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '¿Necesitas ayuda con las tasas?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Consulta nuestra guía de políticas financieras actualizadas para el Q3.',
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
                            'Ver Guía de Tasas',
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
        ),
      ),
      bottomNavigationBar: const AdminNavbar(currentIndex: 2),
    );
  }

  void _showForm(BuildContext context, [InsuranceModel? ins]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<InsurancesCubit>(),
        child: _InsuranceFormSheet(insurance: ins),
      ),
    );
  }
}

class _InsuranceCard extends StatelessWidget {
  final InsuranceModel insurance;
  const _InsuranceCard({required this.insurance});

  @override
  Widget build(BuildContext context) {
    final isVehicular = insurance.type == 'VEHICULAR';
    final iconBg = isVehicular ? AppColors.primaryLight : AppColors.successLight;
    final iconColor = isVehicular ? AppColors.primary : AppColors.success;
    final icon = isVehicular
        ? Icons.directions_car_rounded
        : insurance.type == 'DESGRAVAMEN'
            ? Icons.shield_rounded
            : Icons.people_rounded;

    final rateLabel = insurance.base == 'SALDO_INSOLUTO'
        ? 'TASA MENSUAL'
        : 'TASA ANUAL';
    final rateDisplay =
        '${(insurance.rate * 100).toStringAsFixed(3)}%';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: insurance.isActive ? AppColors.surface : AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insurance.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: insurance.isActive
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isVehicular
                            ? AppColors.primaryLight
                            : AppColors.successLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        insurance.type,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isVehicular
                              ? AppColors.primary
                              : AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: insurance.isActive,
                activeColor: AppColors.primary,
                onChanged: (_) =>
                    context.read<InsurancesCubit>().toggle(insurance.id),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            rateLabel,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            rateDisplay,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: insurance.isActive
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
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
                    value: context.read<InsurancesCubit>(),
                    child: _InsuranceFormSheet(insurance: insurance),
                  ),
                ),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.edit_outlined,
                      color: AppColors.textSecondary, size: 18),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete_outline_rounded,
                    color: AppColors.error, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsuranceFormSheet extends StatefulWidget {
  final InsuranceModel? insurance;
  const _InsuranceFormSheet({this.insurance});

  @override
  State<_InsuranceFormSheet> createState() => _InsuranceFormSheetState();
}

class _InsuranceFormSheetState extends State<_InsuranceFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _rate;
  String _type = 'DESGRAVAMEN';
  String _base = 'SALDO_INSOLUTO';
  bool _mandatory = false;

  bool get _isEdit => widget.insurance != null;

  @override
  void initState() {
    super.initState();
    final ins = widget.insurance;
    _name = TextEditingController(text: ins?.name ?? '');
    _rate = TextEditingController(
        text: ins != null ? ins.rate.toString() : '');
    if (ins != null) {
      _type = ins.type;
      _base = ins.base;
      _mandatory = ins.isMandatory;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _rate.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'name': _name.text.trim(),
      'type': _type,
      'rate': double.parse(_rate.text.trim()),
      'base': _base,
      'isMandatory': _mandatory,
    };
    if (_isEdit) {
      context.read<InsurancesCubit>().update(widget.insurance!.id, data);
    } else {
      context.read<InsurancesCubit>().create(data);
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
                _isEdit ? 'Editar Seguro' : 'Nuevo Seguro',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),

              _label('NOMBRE'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _name,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Requerido.' : null,
                decoration:
                    const InputDecoration(hintText: 'Seguro Desgravamen'),
              ),
              const SizedBox(height: 14),

              _label('TIPO'),
              const SizedBox(height: 8),
              _dropdown(
                value: _type,
                options: const ['DESGRAVAMEN', 'VEHICULAR', 'OTHER'],
                onChanged: (v) => setState(() => _type = v),
              ),
              const SizedBox(height: 14),

              _label('TASA (decimal, ej: 0.00035)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _rate,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Requerido.' : null,
                decoration: const InputDecoration(hintText: '0.00035'),
              ),
              const SizedBox(height: 14),

              _label('BASE DE CÁLCULO'),
              const SizedBox(height: 8),
              _dropdown(
                value: _base,
                options: const [
                  'SALDO_INSOLUTO',
                  'VALOR_VEHICULO',
                  'MONTO_PRESTAMO'
                ],
                onChanged: (v) => setState(() => _base = v),
              ),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Obligatorio',
                      style: TextStyle(
                          fontSize: 14, color: AppColors.textPrimary)),
                  Switch(
                    value: _mandatory,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => _mandatory = v),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  child:
                      Text(_isEdit ? 'Guardar cambios' : 'Crear seguro'),
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

  Widget _dropdown({
    required String value,
    required List<String> options,
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
            items: options
                .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                .toList(),
            onChanged: (v) { if (v != null) onChanged(v); },
          ),
        ),
      );
}