import 'package:dartz/dartz.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/loan.dart';
import '../../domain/repositories/creditos_repository.dart';
import '../datasources/creditos_remote_datasource.dart';

class CreditosRepositoryImpl implements CreditosRepository {
  final CreditosRemoteDatasource remoteDatasource;
  CreditosRepositoryImpl({required this.remoteDatasource});

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
  Future<Either<Failure, List<LoanSummary>>> getLoans() =>
      _run(() => remoteDatasource.getLoans());

  @override
  Future<Either<Failure, Loan>> getLoan(int id) =>
      _run(() => remoteDatasource.getLoan(id));

  @override
  Future<Either<Failure, void>> updateLoanStatus(int id, String status,
          {String? reason}) =>
      _run(() => remoteDatasource.updateLoanStatus(id, status, reason: reason));
}