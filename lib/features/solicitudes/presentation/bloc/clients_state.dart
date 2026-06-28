part of 'clients_cubit.dart';

abstract class ClientsState extends Equatable {
  const ClientsState();
  @override
  List<Object?> get props => [];
}

class ClientsInitial extends ClientsState { const ClientsInitial(); }
class ClientsLoading extends ClientsState { const ClientsLoading(); }

class ClientsLoaded extends ClientsState {
  final List<Client> clients;
  final List<Client> filtered;
  final String query;
  const ClientsLoaded({required this.clients, required this.filtered, this.query = ''});
  @override
  List<Object?> get props => [clients, filtered, query];
}

class ClientsError extends ClientsState {
  final String message;
  const ClientsError(this.message);
  @override
  List<Object?> get props => [message];
}

class ClientMutating extends ClientsState { const ClientMutating(); }

class ClientMutationSuccess extends ClientsState {
  final String message;
  const ClientMutationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ClientMutationError extends ClientsState {
  final String message;
  const ClientMutationError(this.message);
  @override
  List<Object?> get props => [message];
}