import 'package:dartz/dartz.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/simulation.dart';
import '../../domain/repositories/simular_repository.dart';
import '../datasources/simular_remote_datasource.dart';

class SimularRepositoryImpl implements SimularRepository {
  final SimularRemoteDatasource remoteDatasource;
  SimularRepositoryImpl({required this.remoteDatasource});

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
  Future<Either<Failure, List<SimulationSummary>>> getSimulations() =>
      _run(() => remoteDatasource.getSimulations());

  @override
  Future<Either<Failure, Simulation>> getSimulation(int id) =>
      _run(() => remoteDatasource.getSimulation(id));

  @override
  Future<Either<Failure, Simulation>> createSimulation(
          Map<String, dynamic> data) =>
      _run(() => remoteDatasource.createSimulation(data));

  @override
  Future<Either<Failure, void>> deleteSimulation(int id) =>
      _run(() => remoteDatasource.deleteSimulation(id));

  @override
  Future<Either<Failure, void>> convertToLoan(int id) =>
      _run(() => remoteDatasource.convertToLoan(id));
}