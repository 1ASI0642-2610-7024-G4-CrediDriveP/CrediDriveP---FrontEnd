import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/loan.dart';
import '../../domain/usecases/loan_usecases.dart';

part 'creditos_state.dart';

class CreditosCubit extends Cubit<CreditosState> {
  final GetLoansUsecase _getLoans;

  CreditosCubit({required GetLoansUsecase getLoans})
      : _getLoans = getLoans,
        super(const CreditosInitial());

  Future<void> load() async {
    emit(const CreditosLoading());
    final result = await _getLoans();
    result.fold(
      (f) => emit(CreditosError(f.message)),
      (list) => emit(CreditosLoaded(list)),
    );
  }

  Future<void> refresh() => load();
}

// ── Detalle Cubit ─────────────────────────────────────────────────────────────

class LoanDetailCubit extends Cubit<LoanDetailState> {
  final GetLoanUsecase _getLoan;
  final UpdateLoanStatusUsecase _updateStatus;

  LoanDetailCubit({
    required GetLoanUsecase getLoan,
    required UpdateLoanStatusUsecase updateStatus,
  })  : _getLoan = getLoan,
        _updateStatus = updateStatus,
        super(const LoanDetailInitial());

  Future<void> load(int id) async {
    emit(const LoanDetailLoading());
    final result = await _getLoan(id);
    result.fold(
      (f) => emit(LoanDetailError(f.message)),
      (loan) => emit(LoanDetailLoaded(loan)),
    );
  }

  Future<void> approve(int id, {String? reason}) async {
    emit(const LoanStatusUpdating());
    final result = await _updateStatus(id, 'APPROVED', reason: reason);
    result.fold(
      (f) => emit(LoanDetailError(f.message)),
      (_) {
        emit(const LoanStatusUpdated('Préstamo aprobado.'));
        load(id);
      },
    );
  }

  Future<void> reject(int id, {String? reason}) async {
    emit(const LoanStatusUpdating());
    final result = await _updateStatus(id, 'REJECTED', reason: reason);
    result.fold(
      (f) => emit(LoanDetailError(f.message)),
      (_) {
        emit(const LoanStatusUpdated('Préstamo rechazado.'));
        load(id);
      },
    );
  }

  Future<void> activate(int id) async {
    emit(const LoanStatusUpdating());
    final result = await _updateStatus(id, 'ACTIVE');
    result.fold(
      (f) => emit(LoanDetailError(f.message)),
      (_) {
        emit(const LoanStatusUpdated('Préstamo activado.'));
        load(id);
      },
    );
  }
}