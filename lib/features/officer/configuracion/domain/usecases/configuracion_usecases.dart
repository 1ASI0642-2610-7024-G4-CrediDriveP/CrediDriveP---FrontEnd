import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/configuracion_repository.dart';

class GetProfileUsecase {
  final ConfiguracionRepository repository;
  GetProfileUsecase(this.repository);
  Future<Either<Failure, UserProfile>> call() => repository.getProfile();
}

class LogoutUsecase {
  final ConfiguracionRepository repository;
  LogoutUsecase(this.repository);
  Future<Either<Failure, void>> call() => repository.logout();
}