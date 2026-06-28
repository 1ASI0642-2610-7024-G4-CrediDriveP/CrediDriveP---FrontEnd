import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final FlutterSecureStorage storage;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.storage,
  });

  @override
  Future<Either<Failure, AuthUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDatasource.login(
        email: email,
        password: password,
      );
      // Persistir JWT y datos básicos
      await storage.write(key: kTokenKey, value: user.token);
      await storage.write(key: kRoleKey, value: user.role);
      await storage.write(key: kUserNameKey, value: user.name);
      return Right(user);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
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

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final token = await storage.read(key: kTokenKey);
      return Right(token != null);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
