import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/simulation.dart';
import '../../domain/usecases/simulation_usecases.dart';

part 'simular_state.dart';

class SimularCubit extends Cubit<SimularState> {
  final CreateSimulationUsecase _create;
  final ConvertToLoanUsecase _convert;

  SimularCubit({
    required CreateSimulationUsecase create,
    required ConvertToLoanUsecase convert,
  })  : _create = create,
        _convert = convert,
        super(const SimularInitial());

  Future<void> calculate(Map<String, dynamic> data) async {
    emit(const SimularLoading());
    final result = await _create(data);
    result.fold(
      (f) => emit(SimularError(f.message)),
      (sim) => emit(SimularResult(sim)),
    );
  }

  Future<void> convertToLoan(int id) async {
    emit(const SimularConverting());
    final result = await _convert(id);
    result.fold(
      (f) => emit(SimularError(f.message)),
      (_) => emit(const SimularConvertSuccess()),
    );
  }

  void reset() => emit(const SimularInitial());
}

// ── Historial Cubit ───────────────────────────────────────────────────────────

class HistorialCubit extends Cubit<HistorialState> {
  final GetSimulationsUsecase _getSimulations;
  final DeleteSimulationUsecase _delete;

  HistorialCubit({
    required GetSimulationsUsecase getSimulations,
    required DeleteSimulationUsecase delete,
  })  : _getSimulations = getSimulations,
        _delete = delete,
        super(const HistorialInitial());

  Future<void> load() async {
    emit(const HistorialLoading());
    final result = await _getSimulations();
    result.fold(
      (f) => emit(HistorialError(f.message)),
      (list) => emit(HistorialLoaded(list)),
    );
  }

  Future<void> delete(int id) async {
    final result = await _delete(id);
    result.fold(
      (f) => emit(HistorialError(f.message)),
      (_) => load(),
    );
  }
}