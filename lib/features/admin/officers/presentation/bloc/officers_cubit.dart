import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/datasources/officers_datasource.dart';
import '../../data/models/officer_model.dart';

part 'officers_state.dart';

class OfficersCubit extends Cubit<OfficersState> {
  final OfficersDatasource _datasource;

  OfficersCubit(this._datasource) : super(const OfficersInitial());

  Future<void> load() async {
    emit(const OfficersLoading());
    try {
      final list = await _datasource.getOfficers();
      emit(OfficersLoaded(officers: list, filtered: list));
    } catch (e) {
      emit(OfficersError(e.toString()));
    }
  }

  void search(String query) {
    final state = this.state;
    if (state is! OfficersLoaded) return;
    final q = query.toLowerCase();
    final filtered = q.isEmpty
        ? state.officers
        : state.officers
            .where((o) =>
                o.name.toLowerCase().contains(q) ||
                o.email.toLowerCase().contains(q))
            .toList();
    emit(OfficersLoaded(officers: state.officers, filtered: filtered));
  }

  Future<void> create(Map<String, dynamic> data) async {
    try {
      await _datasource.createOfficer(data);
      emit(const OfficerMutationSuccess('Officer creado correctamente.'));
      load();
    } catch (e) {
      emit(OfficerMutationError(e.toString()));
    }
  }

  Future<void> update(int id, Map<String, dynamic> data) async {
    try {
      await _datasource.updateOfficer(id, data);
      emit(const OfficerMutationSuccess('Officer actualizado.'));
      load();
    } catch (e) {
      emit(OfficerMutationError(e.toString()));
    }
  }

  Future<void> toggle(int id) async {
    try {
      await _datasource.toggleOfficer(id);
      load();
    } catch (e) {
      emit(OfficerMutationError(e.toString()));
    }
  }

  Future<void> resetPassword(int id, String newPassword) async {
    try {
      await _datasource.resetPassword(id, newPassword);
      emit(const OfficerMutationSuccess('Contraseña reseteada.'));
    } catch (e) {
      emit(OfficerMutationError(e.toString()));
    }
  }
}