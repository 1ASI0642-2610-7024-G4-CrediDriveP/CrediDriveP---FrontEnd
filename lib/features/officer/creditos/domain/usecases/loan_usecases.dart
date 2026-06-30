import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/loan.dart';
import '../repositories/creditos_repository.dart';

class GetLoansUsecase {
  final CreditosRepository repository;
  GetLoansUsecase(this.repository);
  Future<Either<Failure, List<LoanSummary>>> call() => repository.getLoans();
}

class GetLoanUsecase {
  final CreditosRepository repository;
  GetLoanUsecase(this.repository);
  Future<Either<Failure, Loan>> call(int id) => repository.getLoan(id);
}

class UpdateLoanStatusUsecase {
  final CreditosRepository repository;
  UpdateLoanStatusUsecase(this.repository);
  Future<Either<Failure, void>> call(int id, String status, {String? reason}) =>
      repository.updateLoanStatus(id, status, reason: reason);
}