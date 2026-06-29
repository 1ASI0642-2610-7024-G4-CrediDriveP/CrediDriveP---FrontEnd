import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/datasources/commissions_datasource.dart';
import '../../data/models/commission_model.dart';

part 'commissions_state.dart';

class CommissionsCubit extends Cubit<CommissionsState> {
  final CommissionsDatasource _datasource;

  CommissionsCubit(this._datasource) : super(const CommissionsInitial());

  Future<void> load() async {
    emit(const CommissionsLoading());
    try {
      final list = await _datasource.getCommissions();
      emit(CommissionsLoaded(list));
    } catch (e) {
      emit(CommissionsError(e.toString()));
    }
  }

  Future<void> create(Map<String, dynamic> data) async {
    try {
      await _datasource.createCommission(data);
      emit(const CommissionMutationSuccess('Comisión creada.'));
      load();
    } catch (e) {
      emit(CommissionsError(e.toString()));
    }
  }

  Future<void> update(int id, Map<String, dynamic> data) async {
    try {
      await _datasource.updateCommission(id, data);
      emit(const CommissionMutationSuccess('Comisión actualizada.'));
      load();
    } catch (e) {
      emit(CommissionsError(e.toString()));
    }
  }

  Future<void> toggle(int id) async {
    try {
      await _datasource.toggleCommission(id);
      load();
    } catch (e) {
      emit(CommissionsError(e.toString()));
    }
  }
}