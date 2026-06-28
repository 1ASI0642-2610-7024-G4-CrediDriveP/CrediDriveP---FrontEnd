import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/simulation.dart';
import '../repositories/simular_repository.dart';

class GetSimulationsUsecase {
  final SimularRepository repository;
  GetSimulationsUsecase(this.repository);
  Future<Either<Failure, List<SimulationSummary>>> call() =>
      repository.getSimulations();
}

class GetSimulationUsecase {
  final SimularRepository repository;
  GetSimulationUsecase(this.repository);
  Future<Either<Failure, Simulation>> call(int id) =>
      repository.getSimulation(id);
}

class CreateSimulationUsecase {
  final SimularRepository repository;
  CreateSimulationUsecase(this.repository);
  Future<Either<Failure, Simulation>> call(Map<String, dynamic> data) =>
      repository.createSimulation(data);
}

class DeleteSimulationUsecase {
  final SimularRepository repository;
  DeleteSimulationUsecase(this.repository);
  Future<Either<Failure, void>> call(int id) =>
      repository.deleteSimulation(id);
}

class ConvertToLoanUsecase {
  final SimularRepository repository;
  ConvertToLoanUsecase(this.repository);
  Future<Either<Failure, void>> call(int id) =>
      repository.convertToLoan(id);
}