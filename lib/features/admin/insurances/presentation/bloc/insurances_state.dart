part of 'insurances_cubit.dart';

abstract class InsurancesState extends Equatable {
  const InsurancesState();
  @override
  List<Object?> get props => [];
}

class InsurancesInitial extends InsurancesState { const InsurancesInitial(); }
class InsurancesLoading extends InsurancesState { const InsurancesLoading(); }

class InsurancesLoaded extends InsurancesState {
  final List<InsuranceModel> insurances;
  const InsurancesLoaded(this.insurances);
  @override
  List<Object?> get props => [insurances];
}

class InsurancesError extends InsurancesState {
  final String message;
  const InsurancesError(this.message);
  @override
  List<Object?> get props => [message];
}

class InsuranceMutationSuccess extends InsurancesState {
  final String message;
  const InsuranceMutationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}