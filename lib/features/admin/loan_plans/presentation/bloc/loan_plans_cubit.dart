import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/datasources/loan_plans_datasource.dart';
import '../../data/models/loan_plan_model.dart';

part 'loan_plans_state.dart';

class LoanPlansCubit extends Cubit<LoanPlansState> {
  final LoanPlansDatasource _datasource;

  LoanPlansCubit(this._datasource) : super(const LoanPlansInitial());

  Future<void> load() async {
    emit(const LoanPlansLoading());
    try {
      final list = await _datasource.getLoanPlans();
      emit(LoanPlansLoaded(list));
    } catch (e) {
      emit(LoanPlansError(e.toString()));
    }
  }

  void filter(String f) {
    final state = this.state;
    if (state is! LoanPlansLoaded) return;
    emit(LoanPlansLoaded(state.plans, activeFilter: f));
  }

  Future<void> create(Map<String, dynamic> data) async {
    try {
      await _datasource.createLoanPlan(data);
      emit(const LoanPlanMutationSuccess('Plan creado correctamente.'));
      load();
    } catch (e) {
      emit(LoanPlansError(e.toString()));
    }
  }

  Future<void> update(int id, Map<String, dynamic> data) async {
    try {
      await _datasource.updateLoanPlan(id, data);
      emit(const LoanPlanMutationSuccess('Plan actualizado.'));
      load();
    } catch (e) {
      emit(LoanPlansError(e.toString()));
    }
  }

  Future<void> toggle(int id) async {
    try {
      await _datasource.toggleLoanPlan(id);
      load();
    } catch (e) {
      emit(LoanPlansError(e.toString()));
    }
  }
}