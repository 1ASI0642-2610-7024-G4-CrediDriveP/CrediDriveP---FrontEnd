import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';

abstract class ConfiguracionRepository {
  Future<Either<Failure, UserProfile>> getProfile();
  Future<Either<Failure, void>> logout();
}