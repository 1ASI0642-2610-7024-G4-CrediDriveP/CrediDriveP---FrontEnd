part of 'officers_cubit.dart';

abstract class OfficersState extends Equatable {
  const OfficersState();
  @override
  List<Object?> get props => [];
}

class OfficersInitial extends OfficersState { const OfficersInitial(); }
class OfficersLoading extends OfficersState { const OfficersLoading(); }

class OfficersLoaded extends OfficersState {
  final List<OfficerModel> officers;
  final List<OfficerModel> filtered;
  const OfficersLoaded({required this.officers, required this.filtered});
  @override
  List<Object?> get props => [officers, filtered];
}

class OfficersError extends OfficersState {
  final String message;
  const OfficersError(this.message);
  @override
  List<Object?> get props => [message];
}

class OfficerMutationSuccess extends OfficersState {
  final String message;
  const OfficerMutationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class OfficerMutationError extends OfficersState {
  final String message;
  const OfficerMutationError(this.message);
  @override
  List<Object?> get props => [message];
}