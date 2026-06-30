import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/client.dart';
import '../bloc/clients_cubit.dart';

class ClientFormSheet extends StatefulWidget {
  final Client? client; // null = crear, non-null = editar

  const ClientFormSheet({super.key, this.client});

  @override
  State<ClientFormSheet> createState() => _ClientFormSheetState();
}

class _ClientFormSheetState extends State<ClientFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _dni;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _phone;
  late final TextEditingController _income;
  late final TextEditingController _score;

  bool get _isEdit => widget.client != null;

  @override
  void initState() {
    super.initState();
    final c = widget.client;
    _dni = TextEditingController(text: c?.dni ?? '');
    _firstName = TextEditingController(text: c?.firstName ?? '');
    _lastName = TextEditingController(text: c?.lastName ?? '');
    _phone = TextEditingController(text: c?.phone ?? '');
    _income = TextEditingController(
        text: c != null ? c.monthlyIncome.toStringAsFixed(2) : '');
    _score = TextEditingController(
        text: c != null ? c.creditScore.toString() : '');
  }

  @override
  void dispose() {
    for (final c in [_dni, _firstName, _lastName, _phone, _income, _score]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'dni': _dni.text.trim(),
      'firstName': _firstName.text.trim(),
      'lastName': _lastName.text.trim(),
      'phone': _phone.text.trim(),
      'monthlyIncome': double.parse(_income.text.trim()),
      'creditScore': int.parse(_score.text.trim()),
    };
    if (_isEdit) {
      context.read<ClientsCubit>().update(widget.client!.id, data);
    } else {
      context.read<ClientsCubit>().create(data);
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
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                _isEdit ? 'Editar Cliente' : 'Nuevo Cliente',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              _field('DNI', _dni, hint: '12345678',
                  keyboardType: TextInputType.number),
              _field('Nombre', _firstName, hint: 'Juan'),
              _field('Apellido', _lastName, hint: 'Pérez'),
              _field('Teléfono', _phone, hint: '987654321',
                  keyboardType: TextInputType.phone),
              _field('Ingreso mensual (S/)', _income,
                  hint: '5000.00',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true)),
              _field('Credit Score', _score,
                  hint: '750', keyboardType: TextInputType.number),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isEdit ? 'Guardar cambios' : 'Crear cliente'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              )),
          const SizedBox(height: 6),
          TextFormField(
            controller: ctrl,
            keyboardType: keyboardType,
            validator: (v) =>
                v == null || v.isEmpty ? 'Campo requerido.' : null,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }
}