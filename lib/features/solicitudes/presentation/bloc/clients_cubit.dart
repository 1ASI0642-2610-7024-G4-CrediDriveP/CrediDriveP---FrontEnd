import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/client.dart';
import '../../domain/usecases/client_usecases.dart';

part 'clients_state.dart';

class ClientsCubit extends Cubit<ClientsState> {
  final GetClientsUsecase _getClients;
  final CreateClientUsecase _createClient;
  final UpdateClientUsecase _updateClient;
  final DeleteClientUsecase _deleteClient;

  ClientsCubit({
    required GetClientsUsecase getClients,
    required CreateClientUsecase createClient,
    required UpdateClientUsecase updateClient,
    required DeleteClientUsecase deleteClient,
  })  : _getClients = getClients,
        _createClient = createClient,
        _updateClient = updateClient,
        _deleteClient = deleteClient,
        super(const ClientsInitial());

  Future<void> load() async {
    emit(const ClientsLoading());
    final result = await _getClients();
    result.fold(
      (f) => emit(ClientsError(f.message)),
      (list) => emit(ClientsLoaded(clients: list, filtered: list)),
    );
  }

  void search(String query) {
    final current = state;
    if (current is! ClientsLoaded) return;
    final q = query.toLowerCase();
    final filtered = q.isEmpty
        ? current.clients
        : current.clients.where((c) =>
            c.fullName.toLowerCase().contains(q) ||
            c.dni.contains(q)).toList();
    emit(ClientsLoaded(clients: current.clients, filtered: filtered, query: query));
  }

  Future<void> create(Map<String, dynamic> data) async {
    emit(const ClientMutating());
    final result = await _createClient(data);
    result.fold(
      (f) => emit(ClientMutationError(f.message)),
      (_) {
        emit(const ClientMutationSuccess('Cliente creado correctamente.'));
        load();
      },
    );
  }

  Future<void> update(int id, Map<String, dynamic> data) async {
    emit(const ClientMutating());
    final result = await _updateClient(id, data);
    result.fold(
      (f) => emit(ClientMutationError(f.message)),
      (_) {
        emit(const ClientMutationSuccess('Cliente actualizado correctamente.'));
        load();
      },
    );
  }

  Future<void> delete(int id) async {
    emit(const ClientMutating());
    final result = await _deleteClient(id);
    result.fold(
      (f) => emit(ClientMutationError(f.message)),
      (_) {
        emit(const ClientMutationSuccess('Cliente eliminado.'));
        load();
      },
    );
  }
}