import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/client.dart';
import '../repositories/solicitudes_repository.dart';

class GetClientsUsecase {
  final SolicitudesRepository repository;
  GetClientsUsecase(this.repository);
  Future<Either<Failure, List<Client>>> call() => repository.getClients();
}

class CreateClientUsecase {
  final SolicitudesRepository repository;
  CreateClientUsecase(this.repository);
  Future<Either<Failure, Client>> call(Map<String, dynamic> data) =>
      repository.createClient(data);
}

class UpdateClientUsecase {
  final SolicitudesRepository repository;
  UpdateClientUsecase(this.repository);
  Future<Either<Failure, Client>> call(int id, Map<String, dynamic> data) =>
      repository.updateClient(id, data);
}

class DeleteClientUsecase {
  final SolicitudesRepository repository;
  DeleteClientUsecase(this.repository);
  Future<Either<Failure, void>> call(int id) => repository.deleteClient(id);
}