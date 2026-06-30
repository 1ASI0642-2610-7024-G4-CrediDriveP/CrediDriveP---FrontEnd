part of 'commissions_cubit.dart';

abstract class CommissionsState extends Equatable {
  const CommissionsState();
  @override
  List<Object?> get props => [];
}

class CommissionsInitial extends CommissionsState { const CommissionsInitial(); }
class CommissionsLoading extends CommissionsState { const CommissionsLoading(); }

class CommissionsLoaded extends CommissionsState {
  final List<CommissionModel> commissions;
  const CommissionsLoaded(this.commissions);
  @override
  List<Object?> get props => [commissions];
}

class CommissionsError extends CommissionsState {
  final String message;
  const CommissionsError(this.message);
  @override
  List<Object?> get props => [message];
}

class CommissionMutationSuccess extends CommissionsState {
  final String message;
  const CommissionMutationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}