import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/configuracion_repository.dart';
import '../datasources/configuracion_remote_datasource.dart';

class ConfiguracionRepositoryImpl implements ConfiguracionRepository {
  final ConfiguracionRemoteDatasource remoteDatasource;
  final FlutterSecureStorage storage;

  ConfiguracionRepositoryImpl({
    required this.remoteDatasource,
    required this.storage,
  });

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      // Primero intenta desde la API
      final profile = await remoteDatasource.getProfile();
      return Right(profile);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (_) {
      // Si falla, lee desde storage local como fallback
      try {
        final name = await storage.read(key: kUserNameKey) ?? '';
        final role = await storage.read(key: kRoleKey) ?? '';
        // El email no lo guardamos en storage, así que leemos de auth/me
        return Left(const ServerFailure());
      } catch (_) {
        return const Left(CacheFailure());
      }
    } on NetworkException catch (_) {
      // Fallback a storage local cuando no hay red
      try {
        final name = await storage.read(key: kUserNameKey) ?? 'Usuario';
        final role = await storage.read(key: kRoleKey) ?? 'OFFICER';
        return Right(UserProfile(name: name, email: '', role: role));
      } catch (_) {
        return const Left(NetworkFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await storage.deleteAll();
      return const Right(null);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}