part of 'configuracion_cubit.dart';

abstract class ConfiguracionState extends Equatable {
  const ConfiguracionState();
  @override
  List<Object?> get props => [];
}

class ConfiguracionInitial extends ConfiguracionState {
  const ConfiguracionInitial();
}

class ConfiguracionLoading extends ConfiguracionState {
  const ConfiguracionLoading();
}

class ConfiguracionLoaded extends ConfiguracionState {
  final UserProfile profile;
  const ConfiguracionLoaded(this.profile);
  @override
  List<Object?> get props => [profile];
}

class ConfiguracionError extends ConfiguracionState {
  final String message;
  const ConfiguracionError(this.message);
  @override
  List<Object?> get props => [message];
}

class ConfiguracionLoggedOut extends ConfiguracionState {
  const ConfiguracionLoggedOut();
}