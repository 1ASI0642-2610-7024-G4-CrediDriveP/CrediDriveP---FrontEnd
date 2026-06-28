import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/simular_cubit.dart';

class SimulationForm extends StatefulWidget {
  const SimulationForm({super.key});

  @override
  State<SimulationForm> createState() => _SimulationFormState();
}

class _SimulationFormState extends State<SimulationForm> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _vehiclePrice = TextEditingController();
  final _downPaymentPct = TextEditingController(text: '20');
  final _termMonths = TextEditingController(text: '24');
  final _interestRate = TextEditingController(text: '12');
  final _cok = TextEditingController(text: '10');
  final _commissionMonthly = TextEditingController(text: '15');
  final _rateDesgravamen = TextEditingController(text: '0.035');
  final _rateVehicular = TextEditingController(text: '0.025');

  // Selectores
  String _currency = 'PEN';
  String _rateType = 'TEA';
  String _capitalization = 'MONTHLY';
  String _graceType = 'NONE';
  int _graceMonths = 0;
  String _paymentMethod = 'FRENCH';

  bool get _showCapitalization => _rateType == 'TNA';

  @override
  void dispose() {
    for (final c in [
      _vehiclePrice, _downPaymentPct, _termMonths, _interestRate,
      _cok, _commissionMonthly, _rateDesgravamen, _rateVehicular
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;

    final price = double.parse(_vehiclePrice.text.trim());
    final downPct = double.parse(_downPaymentPct.text.trim()) / 100;
    final downPayment = price * downPct;
    final rate = double.parse(_interestRate.text.trim()) / 100;
    final cok = double.parse(_cok.text.trim()) / 100;

    final data = {
      'currency': _currency,
      'downPayment': downPayment,
      'rateType': _rateType,
      'interestRate': rate,
      if (_showCapitalization) 'capitalization': _capitalization,
      'termMonths': int.parse(_termMonths.text.trim()),
      'graceType': _graceType,
      'graceMonths': _graceMonths,
      'paymentMethod': _paymentMethod,
      'startDate': DateTime.now().toIso8601String().split('T')[0],
      'cokAnnual': cok,
      'rateDesgravamen': double.parse(_rateDesgravamen.text.trim()) / 100,
      'rateVehicular': double.parse(_rateVehicular.text.trim()) / 100,
      'insuranceBaseDesgrv': 'SALDO_INSOLUTO',
      'insuranceBaseVehic': 'VALOR_VEHICULO',
      'commissionMonthly': double.parse(_commissionMonthly.text.trim()),
      // vehicleId y clientId son opcionales, se pueden agregar luego
    };

    context.read<SimularCubit>().calculate(data);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Precio del vehículo
            _label('PRECIO DEL VEHÍCULO'),
            const SizedBox(height: 8),
            _textField(_vehiclePrice, hint: '45000.00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true)),

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
                      _selector(
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
                      _label('TIPO DE TASA'),
                      const SizedBox(height: 8),
                      _selector(
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

            // Capitalización (solo si TNA)
            if (_showCapitalization) ...[
              const SizedBox(height: 16),
              _label('CAPITALIZACIÓN'),
              const SizedBox(height: 8),
              _selector(
                value: _capitalization,
                options: const ['DAILY', 'MONTHLY', 'QUARTERLY', 'SEMIANNUAL', 'ANNUAL'],
                labels: const ['Diaria', 'Mensual', 'Trimestral', 'Semestral', 'Anual'],
                icon: Icons.calendar_month_rounded,
                onChanged: (v) => setState(() => _capitalization = v),
              ),
            ],

            const SizedBox(height: 16),

            // Plazo + Cuota inicial
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('PLAZO (MESES)'),
                      const SizedBox(height: 8),
                      _textField(_termMonths,
                          hint: '24',
                          keyboardType: TextInputType.number),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('CUOTA INICIAL (%)'),
                      const SizedBox(height: 8),
                      _textField(_downPaymentPct,
                          hint: '20',
                          keyboardType: TextInputType.number),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Tasa de interés
            _label('TASA DE INTERÉS ANUAL (%)'),
            const SizedBox(height: 8),
            _textField(_interestRate, hint: '12.00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true)),

            const SizedBox(height: 16),

            // Periodo gracia + Método pago
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('PERIODO GRACIA'),
                      const SizedBox(height: 8),
                      _selector(
                        value: _graceType,
                        options: const ['NONE', 'PARTIAL', 'TOTAL'],
                        labels: const ['Sin periodo', 'Parcial', 'Total'],
                        icon: Icons.pause_circle_outline_rounded,
                        onChanged: (v) => setState(() {
                          _graceType = v;
                          if (v == 'NONE') _graceMonths = 0;
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('MÉTODO'),
                      const SizedBox(height: 8),
                      _selector(
                        value: _paymentMethod,
                        options: const ['FRENCH', 'FRENCH_BALLOON'],
                        labels: const ['Francés', 'Francés + Balloon'],
                        icon: Icons.auto_graph_rounded,
                        onChanged: (v) => setState(() => _paymentMethod = v),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Meses de gracia (si aplica)
            if (_graceType != 'NONE') ...[
              const SizedBox(height: 16),
              _label('MESES DE GRACIA'),
              const SizedBox(height: 8),
              Row(
                children: [1, 2, 3, 6].map((m) {
                  final active = _graceMonths == m;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _graceMonths = m),
                      child: Container(
                        width: 48,
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
              ),
            ],

            const SizedBox(height: 16),

            // COK anual
            _label('COK ANUAL (%)'),
            const SizedBox(height: 8),
            _textField(_cok, hint: '10.00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true)),

            const SizedBox(height: 16),

            // Comisión mensual
            _label('COMISIÓN MENSUAL (S/)'),
            const SizedBox(height: 8),
            _textField(_commissionMonthly, hint: '15.00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true)),

            const SizedBox(height: 24),

            // Botón calcular
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
                            width: 22, height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calculate_rounded, size: 20),
                              SizedBox(width: 8),
                              Text('CALCULAR SIMULACIÓN',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3)),
                            ],
                          ),
                  ),
                );
              },
            ),
          ],
        ),
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

  Widget _textField(
    TextEditingController ctrl, {
    String? hint,
    TextInputType? keyboardType,
  }) =>
      TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        validator: (v) => v == null || v.isEmpty ? 'Requerido.' : null,
        decoration: InputDecoration(hintText: hint),
      );

  Widget _selector({
    required String value,
    required List<String> options,
    required List<String> labels,
    required IconData icon,
    required ValueChanged<String> onChanged,
  }) {
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
          items: List.generate(options.length, (i) => DropdownMenuItem(
            value: options[i],
            child: Text(labels[i]),
          )),
          onChanged: (v) { if (v != null) onChanged(v); },
        ),
      ),
    );
  }
}