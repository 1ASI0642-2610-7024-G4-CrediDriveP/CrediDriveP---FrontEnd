import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/simulation.dart';

abstract class SimularRepository {
  Future<Either<Failure, List<SimulationSummary>>> getSimulations();
  Future<Either<Failure, Simulation>> getSimulation(int id);
  Future<Either<Failure, Simulation>> createSimulation(Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteSimulation(int id);
  Future<Either<Failure, void>> convertToLoan(int id);
}