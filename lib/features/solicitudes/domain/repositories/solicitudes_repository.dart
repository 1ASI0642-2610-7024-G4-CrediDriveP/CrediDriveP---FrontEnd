import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/client.dart';
import '../entities/vehicle.dart';

abstract class SolicitudesRepository {
  // Clientes
  Future<Either<Failure, List<Client>>> getClients();
  Future<Either<Failure, Client>> getClient(int id);
  Future<Either<Failure, Client>> createClient(Map<String, dynamic> data);
  Future<Either<Failure, Client>> updateClient(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteClient(int id);

  // Vehículos
  Future<Either<Failure, List<Vehicle>>> getVehicles({String? status, String? brand});
  Future<Either<Failure, Vehicle>> getVehicle(int id);
  Future<Either<Failure, Vehicle>> createVehicle(Map<String, dynamic> data);
  Future<Either<Failure, Vehicle>> updateVehicle(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteVehicle(int id);
}