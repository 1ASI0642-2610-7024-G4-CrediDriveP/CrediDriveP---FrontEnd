import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/usecases/vehicle_usecases.dart';

part 'vehicles_state.dart';

class VehiclesCubit extends Cubit<VehiclesState> {
  final GetVehiclesUsecase _getVehicles;
  final CreateVehicleUsecase _createVehicle;
  final UpdateVehicleUsecase _updateVehicle;
  final DeleteVehicleUsecase _deleteVehicle;

  VehiclesCubit({
    required GetVehiclesUsecase getVehicles,
    required CreateVehicleUsecase createVehicle,
    required UpdateVehicleUsecase updateVehicle,
    required DeleteVehicleUsecase deleteVehicle,
  })  : _getVehicles = getVehicles,
        _createVehicle = createVehicle,
        _updateVehicle = updateVehicle,
        _deleteVehicle = deleteVehicle,
        super(const VehiclesInitial());

  Future<void> load() async {
    emit(const VehiclesLoading());
    final result = await _getVehicles();
    result.fold(
      (f) => emit(VehiclesError(f.message)),
      (list) => emit(VehiclesLoaded(vehicles: list, filtered: list)),
    );
  }

  void filter(String label) {
    final current = state;
    if (current is! VehiclesLoaded) return;
    List<Vehicle> filtered;
    switch (label) {
      case 'Disponibles':
        filtered = current.vehicles.where((v) => v.status == 'AVAILABLE').toList();
        break;
      case 'SUV':
        filtered = current.vehicles.where((v) =>
            v.model.toLowerCase().contains('suv') ||
            v.brand.toLowerCase().contains('suv')).toList();
        break;
      case 'Camionetas':
        filtered = current.vehicles.where((v) =>
            v.model.toLowerCase().contains('hilux') ||
            v.model.toLowerCase().contains('ranger') ||
            v.model.toLowerCase().contains('navara')).toList();
        break;
      default:
        filtered = current.vehicles;
    }
    emit(VehiclesLoaded(
      vehicles: current.vehicles,
      filtered: filtered,
      activeFilter: label,
    ));
  }

  void search(String query) {
    final current = state;
    if (current is! VehiclesLoaded) return;
    final q = query.toLowerCase();
    final filtered = q.isEmpty
        ? current.vehicles
        : current.vehicles.where((v) =>
            v.brand.toLowerCase().contains(q) ||
            v.model.toLowerCase().contains(q)).toList();
    emit(VehiclesLoaded(
      vehicles: current.vehicles,
      filtered: filtered,
      activeFilter: current.activeFilter,
    ));
  }

  Future<void> create(Map<String, dynamic> data) async {
    emit(const VehicleMutating());
    final result = await _createVehicle(data);
    result.fold(
      (f) => emit(VehicleMutationError(f.message)),
      (_) {
        emit(const VehicleMutationSuccess('Vehículo creado correctamente.'));
        load();
      },
    );
  }

  Future<void> update(int id, Map<String, dynamic> data) async {
    emit(const VehicleMutating());
    final result = await _updateVehicle(id, data);
    result.fold(
      (f) => emit(VehicleMutationError(f.message)),
      (_) {
        emit(const VehicleMutationSuccess('Vehículo actualizado.'));
        load();
      },
    );
  }

  Future<void> delete(int id) async {
    emit(const VehicleMutating());
    final result = await _deleteVehicle(id);
    result.fold(
      (f) => emit(VehicleMutationError(f.message)),
      (_) {
        emit(const VehicleMutationSuccess('Vehículo eliminado.'));
        load();
      },
    );
  }
}