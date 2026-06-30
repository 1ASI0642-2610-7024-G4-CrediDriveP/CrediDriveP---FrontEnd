part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final AuthUser user;
  final String redirectTo; // ← destino según rol
  const LoginSuccess(this.user, this.redirectTo);
  @override
  List<Object?> get props => [user, redirectTo];
}

class LoginFailure extends LoginState {
  final String message;
  const LoginFailure(this.message);
  @override
  List<Object?> get props => [message];
}