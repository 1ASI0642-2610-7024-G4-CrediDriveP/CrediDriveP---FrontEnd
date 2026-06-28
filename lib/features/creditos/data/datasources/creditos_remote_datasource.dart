import 'package:dio/dio.dart';
import '../models/loan_model.dart';

abstract class CreditosRemoteDatasource {
  Future<List<LoanSummaryModel>> getLoans();
  Future<LoanModel> getLoan(int id);
  Future<void> updateLoanStatus(int id, String status, {String? reason});
}

class CreditosRemoteDatasourceImpl implements CreditosRemoteDatasource {
  final Dio _dio;
  CreditosRemoteDatasourceImpl(this._dio);

  @override
  Future<List<LoanSummaryModel>> getLoans() async {
    final res = await _dio.get('/loans');
    return (res.data as List)
        .map((e) => LoanSummaryModel.fromJson(e))
        .toList();
  }

  @override
  Future<LoanModel> getLoan(int id) async {
    final res = await _dio.get('/loans/$id');
    return LoanModel.fromJson(res.data);
  }

  @override
  Future<void> updateLoanStatus(int id, String status,
      {String? reason}) async {
    await _dio.put('/loans/$id/status', data: {
      'status': status,
      if (reason != null) 'reason': reason,
    });
  }
}