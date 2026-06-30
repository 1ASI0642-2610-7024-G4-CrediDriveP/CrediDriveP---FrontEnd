part of 'loan_plans_cubit.dart';

abstract class LoanPlansState extends Equatable {
  const LoanPlansState();
  @override
  List<Object?> get props => [];
}

class LoanPlansInitial extends LoanPlansState { const LoanPlansInitial(); }
class LoanPlansLoading extends LoanPlansState { const LoanPlansLoading(); }

class LoanPlansLoaded extends LoanPlansState {
  final List<LoanPlanModel> plans;
  final String activeFilter; // 'TODOS' | 'ACTIVOS'
  const LoanPlansLoaded(this.plans, {this.activeFilter = 'TODOS'});
  @override
  List<Object?> get props => [plans, activeFilter];

  List<LoanPlanModel> get filtered => activeFilter == 'ACTIVOS'
      ? plans.where((p) => p.isActive).toList()
      : plans;
}

class LoanPlansError extends LoanPlansState {
  final String message;
  const LoanPlansError(this.message);
  @override
  List<Object?> get props => [message];
}

class LoanPlanMutationSuccess extends LoanPlansState {
  final String message;
  const LoanPlanMutationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}