import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/configuracion_usecases.dart';

part 'configuracion_state.dart';

class ConfiguracionCubit extends Cubit<ConfiguracionState> {
  final GetProfileUsecase _getProfile;
  final LogoutUsecase _logout;

  ConfiguracionCubit({
    required GetProfileUsecase getProfile,
    required LogoutUsecase logout,
  })  : _getProfile = getProfile,
        _logout = logout,
        super(const ConfiguracionInitial());

  Future<void> load() async {
    emit(const ConfiguracionLoading());
    final result = await _getProfile();
    result.fold(
      (f) => emit(ConfiguracionError(f.message)),
      (profile) => emit(ConfiguracionLoaded(profile)),
    );
  }

  Future<void> logout() async {
    final result = await _logout();
    result.fold(
      (f) => emit(ConfiguracionError(f.message)),
      (_) => emit(const ConfiguracionLoggedOut()),
    );
  }
}