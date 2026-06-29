part of 'simular_cubit.dart';

abstract class SimularState extends Equatable {
  const SimularState();
  @override
  List<Object?> get props => [];
}

class SimularInitial extends SimularState { const SimularInitial(); }
class SimularLoading extends SimularState { const SimularLoading(); }

class SimularResult extends SimularState {
  final Simulation simulation;
  const SimularResult(this.simulation);
  @override
  List<Object?> get props => [simulation];
}

class SimularError extends SimularState {
  final String message;
  const SimularError(this.message);
  @override
  List<Object?> get props => [message];
}

class SimularConverting extends SimularState { const SimularConverting(); }

class SimularConvertSuccess extends SimularState {
  const SimularConvertSuccess();
}

// ── Historial ────────────────────────────────────────────────────────────────

abstract class HistorialState extends Equatable {
  const HistorialState();
  @override
  List<Object?> get props => [];
}

class HistorialInitial extends HistorialState { const HistorialInitial(); }
class HistorialLoading extends HistorialState { const HistorialLoading(); }

class HistorialLoaded extends HistorialState {
  final List<SimulationSummary> simulations;
  const HistorialLoaded(this.simulations);
  @override
  List<Object?> get props => [simulations];
}

class HistorialError extends HistorialState {
  final String message;
  const HistorialError(this.message);
  @override
  List<Object?> get props => [message];
}