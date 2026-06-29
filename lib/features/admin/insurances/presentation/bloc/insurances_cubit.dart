import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/datasources/insurances_datasource.dart';
import '../../data/models/insurance_model.dart';

part 'insurances_state.dart';

class InsurancesCubit extends Cubit<InsurancesState> {
  final InsurancesDatasource _datasource;

  InsurancesCubit(this._datasource) : super(const InsurancesInitial());

  Future<void> load() async {
    emit(const InsurancesLoading());
    try {
      final list = await _datasource.getInsurances();
      emit(InsurancesLoaded(list));
    } catch (e) {
      emit(InsurancesError(e.toString()));
    }
  }

  Future<void> create(Map<String, dynamic> data) async {
    try {
      await _datasource.createInsurance(data);
      emit(const InsuranceMutationSuccess('Seguro creado.'));
      load();
    } catch (e) {
      emit(InsurancesError(e.toString()));
    }
  }

  Future<void> update(int id, Map<String, dynamic> data) async {
    try {
      await _datasource.updateInsurance(id, data);
      emit(const InsuranceMutationSuccess('Seguro actualizado.'));
      load();
    } catch (e) {
      emit(InsurancesError(e.toString()));
    }
  }

  Future<void> toggle(int id) async {
    try {
      await _datasource.toggleInsurance(id);
      load();
    } catch (e) {
      emit(InsurancesError(e.toString()));
    }
  }
}