import 'package:dio/dio.dart';
import '../models/insurance_model.dart';

abstract class InsurancesDatasource {
  Future<List<InsuranceModel>> getInsurances();
  Future<InsuranceModel> createInsurance(Map<String, dynamic> data);
  Future<InsuranceModel> updateInsurance(int id, Map<String, dynamic> data);
  Future<void> toggleInsurance(int id);
}

class InsurancesDatasourceImpl implements InsurancesDatasource {
  final Dio _dio;
  InsurancesDatasourceImpl(this._dio);

  @override
  Future<List<InsuranceModel>> getInsurances() async {
    final res = await _dio.get('/insurances');
    return (res.data as List).map((e) => InsuranceModel.fromJson(e)).toList();
  }

  @override
  Future<InsuranceModel> createInsurance(Map<String, dynamic> data) async {
    final res = await _dio.post('/insurances', data: data);
    return InsuranceModel.fromJson(res.data);
  }

  @override
  Future<InsuranceModel> updateInsurance(
      int id, Map<String, dynamic> data) async {
    final res = await _dio.put('/insurances/$id', data: data);
    return InsuranceModel.fromJson(res.data);
  }

  @override
  Future<void> toggleInsurance(int id) async {
    await _dio.patch('/insurances/$id/toggle');
  }
}