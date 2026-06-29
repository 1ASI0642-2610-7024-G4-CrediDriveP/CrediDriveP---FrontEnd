part of 'vehicles_cubit.dart';

abstract class VehiclesState extends Equatable {
  const VehiclesState();
  @override
  List<Object?> get props => [];
}

class VehiclesInitial extends VehiclesState { const VehiclesInitial(); }
class VehiclesLoading extends VehiclesState { const VehiclesLoading(); }

class VehiclesLoaded extends VehiclesState {
  final List<Vehicle> vehicles;
  final List<Vehicle> filtered;
  final String activeFilter; // 'Todos' | 'Disponibles' | 'SUV' | etc.
  const VehiclesLoaded({
    required this.vehicles,
    required this.filtered,
    this.activeFilter = 'Todos',
  });
  @override
  List<Object?> get props => [vehicles, filtered, activeFilter];
}

class VehiclesError extends VehiclesState {
  final String message;
  const VehiclesError(this.message);
  @override
  List<Object?> get props => [message];
}

class VehicleMutating extends VehiclesState { const VehicleMutating(); }

class VehicleMutationSuccess extends VehiclesState {
  final String message;
  const VehicleMutationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class VehicleMutationError extends VehiclesState {
  final String message;
  const VehicleMutationError(this.message);
  @override
  List<Object?> get props => [message];
}