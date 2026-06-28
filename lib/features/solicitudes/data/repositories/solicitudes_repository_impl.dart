import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/solicitudes_repository.dart';
import '../datasources/solicitudes_remote_datasource.dart';

class SolicitudesRepositoryImpl implements SolicitudesRepository {
  final SolicitudesRemoteDatasource remoteDatasource;
  SolicitudesRepositoryImpl({required this.remoteDatasource});

  // helper para no repetir el try/catch
  Future<Either<Failure, T>> _run<T>(Future<T> Function() fn) async {
    try {
      return Right(await fn());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Client>>> getClients() =>
      _run(() => remoteDatasource.getClients());

  @override
  Future<Either<Failure, Client>> getClient(int id) =>
      _run(() => remoteDatasource.getClient(id));

  @override
  Future<Either<Failure, Client>> createClient(Map<String, dynamic> data) =>
      _run(() => remoteDatasource.createClient(data));

  @override
  Future<Either<Failure, Client>> updateClient(int id, Map<String, dynamic> data) =>
      _run(() => remoteDatasource.updateClient(id, data));

  @override
  Future<Either<Failure, void>> deleteClient(int id) =>
      _run(() => remoteDatasource.deleteClient(id));

  @override
  Future<Either<Failure, List<Vehicle>>> getVehicles({String? status, String? brand}) =>
      _run(() => remoteDatasource.getVehicles(status: status, brand: brand));

  @override
  Future<Either<Failure, Vehicle>> getVehicle(int id) =>
      _run(() => remoteDatasource.getVehicle(id));

  @override
  Future<Either<Failure, Vehicle>> createVehicle(Map<String, dynamic> data) =>
      _run(() => remoteDatasource.createVehicle(data));

  @override
  Future<Either<Failure, Vehicle>> updateVehicle(int id, Map<String, dynamic> data) =>
      _run(() => remoteDatasource.updateVehicle(id, data));

  @override
  Future<Either<Failure, void>> deleteVehicle(int id) =>
      _run(() => remoteDatasource.deleteVehicle(id));
}