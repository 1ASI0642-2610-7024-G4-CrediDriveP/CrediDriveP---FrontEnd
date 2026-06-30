import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../injection_container.dart';
import '../../../solicitudes/domain/entities/client.dart';
import '../../../solicitudes/domain/entities/vehicle.dart';
import '../../../solicitudes/domain/usecases/client_usecases.dart';
import '../../../solicitudes/domain/usecases/vehicle_usecases.dart';
import '../bloc/simular_cubit.dart';

class SimulationForm extends StatefulWidget {
  const SimulationForm({super.key});

  @override
  State<SimulationForm> createState() => _SimulationFormState();
}

class _SimulationFormState extends State<SimulationForm> {
  final _formKey = GlobalKey<FormState>();

  // ── Controladores ────────────────────────────────────────────────────────
  final _downPayment      = TextEditingController();
  final _interestRate     = TextEditingController(text: '12');
  final _termMonths       = TextEditingController(text: '24');
  final _cok              = TextEditingController(text: '10');
  final _balloonPct       = TextEditingController(text: '20');
  final _commissionMonthly = TextEditingController(text: '15');
  final _rateDesgravamen  = TextEditingController(text: '0.035');
  final _rateVehicular    = TextEditingController(text: '0.025');
  final _simName          = TextEditingController();
  final _exchangeRate     = TextEditingController(text: '3.75');

  // ── Selectores ───────────────────────────────────────────────────────────
  String _currency        = 'PEN';
  String _rateType        = 'TEA';
  String _capitalization  = 'MONTHLY';
  String _graceType       = 'NONE';
  int    _graceMonths     = 0;
  String _paymentMethod   = 'FRENCH';
  String _insuranceBaseDesgrv = 'SALDO_INSOLUTO';
  String _insuranceBaseVehic  = 'VALOR_VEHICULO';
  DateTime _startDate     = DateTime.now();

  // ── Listas de entidades ──────────────────────────────────────────────────
  List<Vehicle> _vehicles = [];
  List<Client>  _clients  = [];
  Vehicle? _selectedVehicle;
  Client?  _selectedClient;
  bool _loadingVehicles = true;
  bool _loadingClients  = true;

  // ── UI ───────────────────────────────────────────────────────────────────
  bool _showAdvanced = false;

  bool get _showCapitalization => _rateType == 'TNA';
  bool get _showBalloon        => _paymentMethod == 'FRENCH_BALLOON';
  bool get _showGraceMonths    => _graceType != 'NONE';
  bool get _showExchangeRate   => _currency == 'USD';

  @override
  void initState() {
    super.initState();
    _loadVehicles();
    _loadClients();
  }

  Future<void> _loadVehicles() async {
    try {
      final result = await sl<GetVehiclesUsecase>()();
      result.fold(
        (_) => setState(() => _loadingVehicles = false),
        (list) => setState(() {
          _vehicles = list;
          _loadingVehicles = false;
        }),
      );
    } catch (_) {
      setState(() => _loadingVehicles = false);
    }
  }

  Future<void> _loadClients() async {
    try {
      final result = await sl<GetClientsUsecase>()();
      result.fold(
        (_) => setState(() => _loadingClients = false),
        (list) => setState(() {
          _clients = list;
          _loadingClients = false;
        }),
      );
    } catch (_) {
      setState(() => _loadingClients = false);
    }
  }

  @override
  void dispose() {
    for (final c in [
      _downPayment, _interestRate, _termMonths, _cok,
      _balloonPct, _commissionMonthly, _rateDesgravamen,
      _rateVehicular, _simName, _exchangeRate,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona un vehículo para continuar.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final rate  = double.parse(_interestRate.text.trim()) / 100;
    final cok   = double.parse(_cok.text.trim()) / 100;
    final down  = double.parse(_downPayment.text.trim());
    final desgrv = double.parse(_rateDesgravamen.text.trim()) / 100;
    final vehic  = double.parse(_rateVehicular.text.trim()) / 100;

    final name = _simName.text.trim().isEmpty
        ? 'SIM-${_selectedVehicle!.brand}-${_selectedVehicle!.model}'
        : _simName.text.trim();

    final data = <String, dynamic>{
      'vehicleId'          : _selectedVehicle!.id,
      if (_selectedClient != null) 'clientId': _selectedClient!.id,
      'name'               : name,
      'currency'           : _currency,
      'downPayment'        : down,
      'rateType'           : _rateType,
      'interestRate'       : rate,
      if (_showCapitalization) 'capitalization': _capitalization,
      'termMonths'         : int.parse(_termMonths.text.trim()),
      'graceType'          : _graceType,
      'graceMonths'        : _graceMonths,
      'paymentMethod'      : _paymentMethod,
      if (_showBalloon)
        'balloonPct': double.parse(_balloonPct.text.trim()) / 100,
      'startDate'          : _startDate.toIso8601String().split('T')[0],
      'cokAnnual'          : cok,
      'rateDesgravamen'    : desgrv,
      'rateVehicular'      : vehic,
      'insuranceBaseDesgrv': _insuranceBaseDesgrv,
      'insuranceBaseVehic' : _insuranceBaseVehic,
      'commissionMonthly'  : double.parse(_commissionMonthly.text.trim()),
      if (_showExchangeRate)
        'exchangeRate': double.parse(_exchangeRate.text.trim()),
    };

    context.read<SimularCubit>().calculate(data);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ══════════════════════════════════════════════════════════════
          // SECCIÓN 1 — BÁSICO
          // ══════════════════════════════════════════════════════════════
          _SectionCard(
            title: 'Datos Básicos',
            icon: Icons.tune_rounded,
            children: [

              // Selector vehículo
              _label('VEHÍCULO *'),
              const SizedBox(height: 8),
              _VehicleSelector(
                vehicles: _vehicles,
                selected: _selectedVehicle,
                loading: _loadingVehicles,
                onChanged: (v) => setState(() {
                  _selectedVehicle = v;
                  // Precio del vehículo como referencia para cuota inicial
                  if (v != null && _downPayment.text.isEmpty) {
                    _downPayment.text =
                        (v.price * 0.2).toStringAsFixed(2);
                  }
                }),
              ),
              const SizedBox(height: 16),

              // Selector cliente (opcional)
              _label('CLIENTE (opcional)'),
              const SizedBox(height: 8),
              _ClientSelector(
                clients: _clients,
                selected: _selectedClient,
                loading: _loadingClients,
                onChanged: (c) => setState(() => _selectedClient = c),
              ),
              const SizedBox(height: 16),

              // Nombre simulación
              _label('NOMBRE DE LA SIMULACIÓN'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _simName,
                decoration: const InputDecoration(
                  hintText: 'Ej: SIM-Toyota-Hilux-Juan',
                ),
              ),
              const SizedBox(height: 16),

              // Moneda + Tipo de tasa
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('MONEDA'),
                        const SizedBox(height: 8),
                        _Selector(
                          value: _currency,
                          options: const ['PEN', 'USD'],
                          labels: const ['Soles (S/)', 'Dólares (\$)'],
                          icon: Icons.attach_money_rounded,
                          onChanged: (v) => setState(() => _currency = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('TIPO TASA'),
                        const SizedBox(height: 8),
                        _Selector(
                          value: _rateType,
                          options: const ['TEA', 'TNA'],
                          labels: const ['Efectiva (TEA)', 'Nominal (TNA)'],
                          icon: Icons.percent_rounded,
                          onChanged: (v) => setState(() => _rateType = v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Tipo de cambio (solo USD)
              if (_showExchangeRate) ...[
                const SizedBox(height: 16),
                _label('TIPO DE CAMBIO (S/ por \$)'),
                const SizedBox(height: 8),
                _TextField(
                  ctrl: _exchangeRate,
                  hint: '3.75',
                  keyboard: const TextInputType.numberWithOptions(decimal: true),
                ),
              ],

              // Capitalización (solo TNA)
              if (_showCapitalization) ...[
                const SizedBox(height: 16),
                _label('CAPITALIZACIÓN'),
                const SizedBox(height: 8),
                _Selector(
                  value: _capitalization,
                  options: const [
                    'DAILY', 'MONTHLY', 'QUARTERLY',
                    'SEMIANNUAL', 'ANNUAL'
                  ],
                  labels: const [
                    'Diaria', 'Mensual', 'Trimestral',
                    'Semestral', 'Anual'
                  ],
                  icon: Icons.calendar_month_rounded,
                  onChanged: (v) => setState(() => _capitalization = v),
                ),
              ],

              const SizedBox(height: 16),

              // Tasa de interés + Plazo
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('TASA INTERÉS (%)'),
                        const SizedBox(height: 8),
                        _TextField(
                          ctrl: _interestRate,
                          hint: '12',
                          keyboard: const TextInputType.numberWithOptions(
                              decimal: true),
                          required: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('PLAZO (MESES)'),
                        const SizedBox(height: 8),
                        _TextField(
                          ctrl: _termMonths,
                          hint: '24',
                          keyboard: TextInputType.number,
                          required: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Cuota inicial (monto)
              _label('CUOTA INICIAL (monto en ${_currency == 'USD' ? '\$' : 'S/'})'),
              const SizedBox(height: 8),
              _TextField(
                ctrl: _downPayment,
                hint: '9000.00',
                keyboard: const TextInputType.numberWithOptions(decimal: true),
                required: true,
                helper: _selectedVehicle != null
                    ? 'Precio del vehículo: '
                      '${_selectedVehicle!.priceCurrency} '
                      '${_selectedVehicle!.price.toStringAsFixed(2)}'
                    : null,
              ),

              const SizedBox(height: 16),

              // Fecha de inicio
              _label('FECHA DE INICIO'),
              const SizedBox(height: 8),
              _DatePickerField(
                date: _startDate,
                onChanged: (d) => setState(() => _startDate = d),
              ),

              const SizedBox(height: 16),

              // Método de pago + Compra inteligente
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('MÉTODO PAGO'),
                        const SizedBox(height: 8),
                        _Selector(
                          value: _paymentMethod,
                          options: const ['FRENCH', 'FRENCH_BALLOON'],
                          labels: const ['Francés', 'Balloon'],
                          icon: Icons.auto_graph_rounded,
                          onChanged: (v) =>
                              setState(() => _paymentMethod = v),
                        ),
                      ],
                    ),
                  ),
                  if (_showBalloon) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('BALLOON (%)'),
                          const SizedBox(height: 8),
                          _TextField(
                            ctrl: _balloonPct,
                            hint: '20',
                            keyboard: const TextInputType.numberWithOptions(
                                decimal: true),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ══════════════════════════════════════════════════════════════
          // SECCIÓN 2 — AVANZADO (colapsable)
          // ══════════════════════════════════════════════════════════════
          _AdvancedSection(
            isOpen: _showAdvanced,
            onToggle: () => setState(() => _showAdvanced = !_showAdvanced),
            children: [

              // Periodo de gracia
              _label('PERIODO DE GRACIA'),
              const SizedBox(height: 8),
              _Selector(
                value: _graceType,
                options: const ['NONE', 'PARTIAL', 'TOTAL'],
                labels: const ['Sin periodo', 'Parcial', 'Total'],
                icon: Icons.pause_circle_outline_rounded,
                onChanged: (v) => setState(() {
                  _graceType = v;
                  if (v == 'NONE') _graceMonths = 0;
                }),
              ),

              if (_showGraceMonths) ...[
                const SizedBox(height: 12),
                _label('MESES DE GRACIA'),
                const SizedBox(height: 8),
                _GraceMonthsSelector(
                  selected: _graceMonths,
                  onChanged: (v) => setState(() => _graceMonths = v),
                ),
              ],

              const SizedBox(height: 16),

              // COK anual
              _label('COK ANUAL (%)'),
              const SizedBox(height: 8),
              _TextField(
                ctrl: _cok,
                hint: '10',
                keyboard: const TextInputType.numberWithOptions(decimal: true),
                helper: 'Costo de Oportunidad del Capital — necesario para VAN',
                required: true,
              ),

              const SizedBox(height: 16),

              // Seguros
              _SectionSubtitle('Seguros'),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('TASA DESGRAVAMEN (%)'),
                        const SizedBox(height: 8),
                        _TextField(
                          ctrl: _rateDesgravamen,
                          hint: '0.035',
                          keyboard: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('TASA VEHICULAR (%)'),
                        const SizedBox(height: 8),
                        _TextField(
                          ctrl: _rateVehicular,
                          hint: '0.025',
                          keyboard: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _label('BASE CÁLCULO DESGRAVAMEN'),
              const SizedBox(height: 8),
              _Selector(
                value: _insuranceBaseDesgrv,
                options: const [
                  'SALDO_INSOLUTO', 'VALOR_VEHICULO', 'MONTO_PRESTAMO'
                ],
                labels: const [
                  'Saldo Insoluto', 'Valor Vehículo', 'Monto Préstamo'
                ],
                icon: Icons.shield_outlined,
                onChanged: (v) =>
                    setState(() => _insuranceBaseDesgrv = v),
              ),

              const SizedBox(height: 14),

              _label('BASE CÁLCULO VEHICULAR'),
              const SizedBox(height: 8),
              _Selector(
                value: _insuranceBaseVehic,
                options: const [
                  'SALDO_INSOLUTO', 'VALOR_VEHICULO', 'MONTO_PRESTAMO'
                ],
                labels: const [
                  'Saldo Insoluto', 'Valor Vehículo', 'Monto Préstamo'
                ],
                icon: Icons.directions_car_outlined,
                onChanged: (v) =>
                    setState(() => _insuranceBaseVehic = v),
              ),

              const SizedBox(height: 16),

              // Comisión mensual
              _SectionSubtitle('Comisiones'),
              const SizedBox(height: 12),

              _label('COMISIÓN MENSUAL (S/)'),
              const SizedBox(height: 8),
              _TextField(
                ctrl: _commissionMonthly,
                hint: '15.00',
                keyboard: const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Botón calcular ─────────────────────────────────────────────
          BlocBuilder<SimularCubit, SimularState>(
            builder: (context, state) {
              final loading = state is SimularLoading;
              return SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: loading ? null : _calculate,
                  child: loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calculate_rounded, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'CALCULAR SIMULACIÓN',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
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
}

// ── Sección card ──────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}

// ── Sección avanzada colapsable ───────────────────────────────────────────────

class _AdvancedSection extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onToggle;
  final List<Widget> children;

  const _AdvancedSection({
    required this.isOpen,
    required this.onToggle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header colapsable
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(
                    Icons.settings_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Parámetros Avanzados',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isOpen ? 'Ocultar' : 'Mostrar',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Contenido colapsable
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 16),
                  ...children,
                ],
              ),
            ),
            crossFadeState: isOpen
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

// ── Subtitle dentro de sección ────────────────────────────────────────────────

class _SectionSubtitle extends StatelessWidget {
  final String text;
  const _SectionSubtitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}

// ── TextField reutilizable ────────────────────────────────────────────────────

class _TextField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final TextInputType? keyboard;
  final bool required;
  final String? helper;

  const _TextField({
    required this.ctrl,
    required this.hint,
    this.keyboard,
    this.required = false,
    this.helper,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      validator: required
          ? (v) => v == null || v.isEmpty ? 'Campo requerido.' : null
          : null,
      decoration: InputDecoration(
        hintText: hint,
        helperText: helper,
        helperStyle: const TextStyle(
          fontSize: 10,
          color: AppColors.textSecondary,
        ),
        helperMaxLines: 2,
      ),
    );
  }
}

// ── Selector / Dropdown ───────────────────────────────────────────────────────

class _Selector extends StatelessWidget {
  final String value;
  final List<String> options;
  final List<String> labels;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const _Selector({
    required this.value,
    required this.options,
    required this.labels,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          icon: Icon(icon, size: 18, color: AppColors.textSecondary),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: AppColors.surface,
          items: List.generate(
            options.length,
            (i) => DropdownMenuItem(
              value: options[i],
              child: Text(labels[i]),
            ),
          ),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

// ── Selector de vehículo ──────────────────────────────────────────────────────

class _VehicleSelector extends StatelessWidget {
  final List<Vehicle> vehicles;
  final Vehicle? selected;
  final bool loading;
  final ValueChanged<Vehicle?> onChanged;

  const _VehicleSelector({
    required this.vehicles,
    required this.selected,
    required this.loading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected != null ? AppColors.primary : AppColors.border,
          width: selected != null ? 2 : 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Vehicle>(
          value: selected,
          isExpanded: true,
          hint: const Text(
            'Selecciona un vehículo...',
            style: TextStyle(color: AppColors.textHint, fontSize: 14),
          ),
          icon: const Icon(Icons.directions_car_rounded,
              size: 18, color: AppColors.textSecondary),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: AppColors.surface,
          items: vehicles.map((v) {
            return DropdownMenuItem<Vehicle>(
              value: v,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      v.displayName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${v.priceCurrency} ${v.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ── Selector de cliente ───────────────────────────────────────────────────────

class _ClientSelector extends StatelessWidget {
  final List<Client> clients;
  final Client? selected;
  final bool loading;
  final ValueChanged<Client?> onChanged;

  const _ClientSelector({
    required this.clients,
    required this.selected,
    required this.loading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Client>(
          value: selected,
          isExpanded: true,
          hint: const Text(
            'Sin cliente asignado (opcional)',
            style: TextStyle(color: AppColors.textHint, fontSize: 14),
          ),
          icon: const Icon(Icons.person_outline_rounded,
              size: 18, color: AppColors.textSecondary),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: AppColors.surface,
          items: [
            const DropdownMenuItem<Client>(
              value: null,
              child: Text(
                'Sin cliente',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ...clients.map((c) => DropdownMenuItem<Client>(
                  value: c,
                  child: Text(
                    '${c.fullName} — DNI ${c.dni}',
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ── DatePicker ────────────────────────────────────────────────────────────────

class _DatePickerField extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _DatePickerField({
    required this.date,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now().subtract(const Duration(days: 30)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.primary,
              ),
            ),
            child: child!,
          ),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Text(
              '${date.day.toString().padLeft(2, '0')}/'
              '${date.month.toString().padLeft(2, '0')}/'
              '${date.year}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.edit_calendar_rounded,
                size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

// ── Selector de meses de gracia ───────────────────────────────────────────────

class _GraceMonthsSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _GraceMonthsSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [1, 2, 3, 6, 12].map((m) {
        final active = selected == m;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onChanged(m),
            child: Container(
              width: 44,
              height: 40,
              decoration: BoxDecoration(
                color: active ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: active ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Center(
                child: Text(
                  '$m',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: active ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}