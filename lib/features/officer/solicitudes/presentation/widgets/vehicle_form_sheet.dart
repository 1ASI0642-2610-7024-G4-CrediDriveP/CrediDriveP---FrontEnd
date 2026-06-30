import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/vehicle.dart';
import '../bloc/vehicles_cubit.dart';

class VehicleFormSheet extends StatefulWidget {
  final Vehicle? vehicle;
  const VehicleFormSheet({super.key, this.vehicle});

  @override
  State<VehicleFormSheet> createState() => _VehicleFormSheetState();
}

class _VehicleFormSheetState extends State<VehicleFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _brand, _model, _year, _price, _vin, _imageUrl, _stock;
  String _condition = 'NEW';
  String _currency = 'USD';

  bool get _isEdit => widget.vehicle != null;

  @override
  void initState() {
    super.initState();
    final v = widget.vehicle;
    _brand = TextEditingController(text: v?.brand ?? '');
    _model = TextEditingController(text: v?.model ?? '');
    _year = TextEditingController(text: v != null ? v.year.toString() : '');
    _price = TextEditingController(
        text: v != null ? v.price.toStringAsFixed(2) : '');
    _vin = TextEditingController(text: v?.vin ?? '');
    _imageUrl = TextEditingController(text: v?.imageUrl ?? '');
    _stock = TextEditingController(
        text: v != null ? v.stock.toString() : '');
    if (v != null) {
      _condition = v.condition;
      _currency = v.priceCurrency;
    }
  }

  @override
  void dispose() {
    for (final c in [_brand, _model, _year, _price, _vin, _imageUrl, _stock]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'brand': _brand.text.trim(),
      'model': _model.text.trim(),
      'year': int.parse(_year.text.trim()),
      'condition': _condition,
      'price': double.parse(_price.text.trim()),
      'priceCurrency': _currency,
      'vin': _vin.text.trim().isEmpty ? null : _vin.text.trim(),
      'imageUrl': _imageUrl.text.trim().isEmpty ? null : _imageUrl.text.trim(),
      'stock': int.parse(_stock.text.trim()),
    };
    if (_isEdit) {
      context.read<VehiclesCubit>().update(widget.vehicle!.id, data);
    } else {
      context.read<VehiclesCubit>().create(data);
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
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isEdit ? 'Editar Vehículo' : 'Nuevo Vehículo',
                style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              _field('Marca', _brand, hint: 'Toyota'),
              _field('Modelo', _model, hint: 'Hilux'),
              _field('Año', _year, hint: '2024',
                  keyboardType: TextInputType.number),
              _field('Precio', _price, hint: '45000.00',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true)),
              _field('Stock', _stock, hint: '12',
                  keyboardType: TextInputType.number),
              _field('VIN (opcional)', _vin,
                  hint: '1HGBH41JXMN109186', required: false),
              _field('URL imagen (opcional)', _imageUrl,
                  hint: 'https://...', required: false),

              // Condición
              const SizedBox(height: 4),
              _label('CONDICIÓN'),
              const SizedBox(height: 8),
              Row(
                children: ['NEW', 'USED'].map((c) {
                  final active = _condition == c;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _condition = c),
                      child: Container(
                        margin: EdgeInsets.only(right: c == 'NEW' ? 8 : 0),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: active ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            c == 'NEW' ? 'Nuevo' : 'Usado',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: active ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 14),

              // Moneda
              _label('MONEDA'),
              const SizedBox(height: 8),
              Row(
                children: ['PEN', 'USD'].map((cur) {
                  final active = _currency == cur;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _currency = cur),
                      child: Container(
                        margin: EdgeInsets.only(right: cur == 'PEN' ? 8 : 0),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: active ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            cur,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: active ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isEdit ? 'Guardar cambios' : 'Crear vehículo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {String? hint, TextInputType? keyboardType, bool required = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(label),
          const SizedBox(height: 6),
          TextFormField(
            controller: ctrl,
            keyboardType: keyboardType,
            validator: required
                ? (v) => v == null || v.isEmpty ? 'Campo requerido.' : null
                : null,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
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