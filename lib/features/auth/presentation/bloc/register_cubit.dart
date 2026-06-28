import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/auth_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _repository;

  RegisterCubit(this._repository) : super(const RegisterInitial());

  // TODO: el registro de officers lo hace solo el ADMIN desde /api/auth/officers
  // Esta pantalla es solo de lectura/informativa por ahora
  void goToLogin() => emit(const RegisterNavigateToLogin());
}
