part of 'creditos_cubit.dart';

abstract class CreditosState extends Equatable {
  const CreditosState();
  @override
  List<Object?> get props => [];
}

class CreditosInitial extends CreditosState { const CreditosInitial(); }
class CreditosLoading extends CreditosState { const CreditosLoading(); }

class CreditosLoaded extends CreditosState {
  final List<LoanSummary> loans;
  const CreditosLoaded(this.loans);
  @override
  List<Object?> get props => [loans];
}

class CreditosError extends CreditosState {
  final String message;
  const CreditosError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── Detalle ──────────────────────────────────────────────────────────────────

abstract class LoanDetailState extends Equatable {
  const LoanDetailState();
  @override
  List<Object?> get props => [];
}

class LoanDetailInitial extends LoanDetailState { const LoanDetailInitial(); }
class LoanDetailLoading extends LoanDetailState { const LoanDetailLoading(); }

class LoanDetailLoaded extends LoanDetailState {
  final Loan loan;
  const LoanDetailLoaded(this.loan);
  @override
  List<Object?> get props => [loan];
}

class LoanDetailError extends LoanDetailState {
  final String message;
  const LoanDetailError(this.message);
  @override
  List<Object?> get props => [message];
}

class LoanStatusUpdating extends LoanDetailState { const LoanStatusUpdating(); }

class LoanStatusUpdated extends LoanDetailState {
  final String message;
  const LoanStatusUpdated(this.message);
  @override
  List<Object?> get props => [message];
}