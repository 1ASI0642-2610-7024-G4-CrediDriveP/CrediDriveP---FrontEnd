import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/loan.dart';

abstract class CreditosRepository {
  Future<Either<Failure, List<LoanSummary>>> getLoans();
  Future<Either<Failure, Loan>> getLoan(int id);
  Future<Either<Failure, void>> updateLoanStatus(
      int id, String status, {String? reason});
}