import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/api/dio_client.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/admin_navbar.dart';
import '../../../../../injection_container.dart';
import '../../data/datasources/officers_datasource.dart';
import '../../data/models/officer_model.dart';
import '../bloc/officers_cubit.dart';

class AdminOfficersPage extends StatelessWidget {
  const AdminOfficersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OfficersCubit(
        OfficersDatasourceImpl(sl<DioClient>().dio),
      )..load(),
      child: const _OfficersView(),
    );
  }
}

class _OfficersView extends StatelessWidget {
  const _OfficersView();

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
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 20, color: AppColors.textPrimary),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Gestión de Officers',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Administra el personal del sistema',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Buscador
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) =>
                          context.read<OfficersCubit>().search(v),
                      decoration: InputDecoration(
                        hintText: 'Buscar por nombre o email...',
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: AppColors.textSecondary, size: 20),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: AppColors.border),
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
                  const SizedBox(width: 10),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.tune_rounded,
                        color: AppColors.textSecondary, size: 20),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Lista
            Expanded(
              child: BlocConsumer<OfficersCubit, OfficersState>(
                listener: (context, state) {
                  if (state is OfficerMutationSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.success,
                    ));
                  }
                  if (state is OfficerMutationError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ));
                  }
                },
                builder: (context, state) {
                  if (state is OfficersLoading || state is OfficersInitial) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    );
                  }
                  if (state is OfficersError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is OfficersLoaded) {
                    if (state.filtered.isEmpty) {
                      return const Center(
                        child: Text('No hay officers registrados.',
                            style:
                                TextStyle(color: AppColors.textSecondary)),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: state.filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, i) => _OfficerCard(
                        officer: state.filtered[i],
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      bottomNavigationBar: const AdminNavbar(currentIndex: 4),
    );
  }

  void _showForm(BuildContext ctx, [OfficerModel? officer]) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: ctx.read<OfficersCubit>(),
        child: _OfficerFormSheet(officer: officer),
      ),
    );
  }
}

class _OfficerCard extends StatelessWidget {
  final OfficerModel officer;
  const _OfficerCard({required this.officer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar con iniciales
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: officer.isActive
                      ? AppColors.primaryLight
                      : AppColors.border,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    officer.initials,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: officer.isActive
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      officer.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      officer.email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Badge estado
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: officer.isActive
                      ? AppColors.successLight
                      : AppColors.errorLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  officer.isActive ? 'ACTIVO' : 'INACTIVO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: officer.isActive
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 10),

          // Acciones fila inferior
          Row(
            children: [
              // Editar
              GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => BlocProvider.value(
                    value: context.read<OfficersCubit>(),
                    child: _OfficerFormSheet(officer: officer),
                  ),
                ),
                child: const Icon(Icons.edit_outlined,
                    color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 16),
              // Reset password
              GestureDetector(
                onTap: () => _showResetPassword(context),
                child: const Icon(Icons.lock_reset_outlined,
                    color: AppColors.primary, size: 22),
              ),
              const Spacer(),
              const Text(
                'ESTATUS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: officer.isActive,
                activeColor: AppColors.primary,
                onChanged: (_) =>
                    context.read<OfficersCubit>().toggle(officer.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showResetPassword(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Resetear contraseña'),
        content: TextField(
          controller: ctrl,
          obscureText: true,
          decoration:
              const InputDecoration(hintText: 'Nueva contraseña...'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<OfficersCubit>()
                  .resetPassword(officer.id, ctrl.text);
            },
            child: const Text('Resetear'),
          ),
        ],
      ),
    );
  }
}

class _OfficerFormSheet extends StatefulWidget {
  final OfficerModel? officer;
  const _OfficerFormSheet({this.officer});

  @override
  State<_OfficerFormSheet> createState() => _OfficerFormSheetState();
}

class _OfficerFormSheetState extends State<_OfficerFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _obscure = true;

  bool get _isEdit => widget.officer != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.officer?.name ?? '');
    _email = TextEditingController(text: widget.officer?.email ?? '');
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final data = {
      'name': _name.text.trim(),
      'email': _email.text.trim(),
      if (!_isEdit) 'password': _password.text.trim(),
    };
    if (_isEdit) {
      context.read<OfficersCubit>().update(widget.officer!.id, data);
    } else {
      context.read<OfficersCubit>().create(data);
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
                _isEdit ? 'Editar Officer' : 'Nuevo Officer',
                style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              _label('NOMBRE COMPLETO'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _name,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Requerido.' : null,
                decoration:
                    const InputDecoration(hintText: 'Ej. Juan Officer'),
              ),
              const SizedBox(height: 14),

              _label('CORREO ELECTRÓNICO'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido.';
                  if (!v.contains('@')) return 'Correo inválido.';
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: 'officer@credidrivep.com'),
              ),

              if (!_isEdit) ...[
                const SizedBox(height: 14),
                _label('CONTRASEÑA'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _password,
                  obscureText: _obscure,
                  validator: (v) =>
                      v == null || v.length < 6 ? 'Mínimo 6 caracteres.' : null,
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          setState(() => _obscure = !_obscure),
                      child: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isEdit ? 'Guardar cambios' : 'Crear officer'),
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