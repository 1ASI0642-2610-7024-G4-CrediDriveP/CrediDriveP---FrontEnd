import 'package:dio/dio.dart';
import '../models/loan_plan_model.dart';

List<dynamic> extractLoanPlansPayload(dynamic data) {
  if (data is List) {
    return data;
  }

  if (data is Map) {
    final map = Map<String, dynamic>.from(data as Map);
    for (final key in ['data', 'items', 'content', 'loanPlans', 'plans']) {
      final value = map[key];
      if (value is List) {
        return value;
      }
    }

    return [map];
  }

  return [];
}

abstract class LoanPlansDatasource {
  Future<List<LoanPlanModel>> getLoanPlans();
  Future<LoanPlanModel> createLoanPlan(Map<String, dynamic> data);
  Future<LoanPlanModel> updateLoanPlan(int id, Map<String, dynamic> data);
  Future<void> toggleLoanPlan(int id);
}

class LoanPlansDatasourceImpl implements LoanPlansDatasource {
  final Dio _dio;
  LoanPlansDatasourceImpl(this._dio);

  @override
  Future<List<LoanPlanModel>> getLoanPlans() async {
    final res = await _dio.get('/loan-plans');
    final payload = extractLoanPlansPayload(res.data);
    return payload
        .whereType<Map>()
        .map((e) => LoanPlanModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<LoanPlanModel> createLoanPlan(Map<String, dynamic> data) async {
    final res = await _dio.post('/loan-plans', data: data);
    return LoanPlanModel.fromJson(res.data);
  }

  @override
  Future<LoanPlanModel> updateLoanPlan(
      int id, Map<String, dynamic> data) async {
    final res = await _dio.put('/loan-plans/$id', data: data);
    return LoanPlanModel.fromJson(res.data);
  }

  @override
  Future<void> toggleLoanPlan(int id) async {
    await _dio.patch('/loan-plans/$id/toggle');
  }
}