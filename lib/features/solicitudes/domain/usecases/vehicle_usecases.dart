import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/vehicle.dart';
import '../repositories/solicitudes_repository.dart';

class GetVehiclesUsecase {
  final SolicitudesRepository repository;
  GetVehiclesUsecase(this.repository);
  Future<Either<Failure, List<Vehicle>>> call({String? status, String? brand}) =>
      repository.getVehicles(status: status, brand: brand);
}

class CreateVehicleUsecase {
  final SolicitudesRepository repository;
  CreateVehicleUsecase(this.repository);
  Future<Either<Failure, Vehicle>> call(Map<String, dynamic> data) =>
      repository.createVehicle(data);
}

class UpdateVehicleUsecase {
  final SolicitudesRepository repository;
  UpdateVehicleUsecase(this.repository);
  Future<Either<Failure, Vehicle>> call(int id, Map<String, dynamic> data) =>
      repository.updateVehicle(id, data);
}

class DeleteVehicleUsecase {
  final SolicitudesRepository repository;
  DeleteVehicleUsecase(this.repository);
  Future<Either<Failure, void>> call(int id) => repository.deleteVehicle(id);
}