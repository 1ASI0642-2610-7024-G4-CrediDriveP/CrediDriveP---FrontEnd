import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/navigation/app_router.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUsecase _loginUsecase;

  LoginCubit(this._loginUsecase) : super(const LoginInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const LoginLoading());

    final result = await _loginUsecase(email: email, password: password);

    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (user) {
        // Redirige según rol
        final destination = user.isAdmin
            ? AppRoutes.adminHome
            : AppRoutes.home;

        emit(LoginSuccess(user, destination));
      },
    );
  }

  void reset() => emit(const LoginInitial());
}