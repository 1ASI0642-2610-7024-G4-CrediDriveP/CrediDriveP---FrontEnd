import 'package:dio/dio.dart';
import '../models/commission_model.dart';

abstract class CommissionsDatasource {
  Future<List<CommissionModel>> getCommissions();
  Future<CommissionModel> createCommission(Map<String, dynamic> data);
  Future<CommissionModel> updateCommission(int id, Map<String, dynamic> data);
  Future<void> toggleCommission(int id);
}

class CommissionsDatasourceImpl implements CommissionsDatasource {
  final Dio _dio;
  CommissionsDatasourceImpl(this._dio);

  @override
  Future<List<CommissionModel>> getCommissions() async {
    final res = await _dio.get('/commissions');
    return (res.data as List)
        .map((e) => CommissionModel.fromJson(e))
        .toList();
  }

  @override
  Future<CommissionModel> createCommission(Map<String, dynamic> data) async {
    final res = await _dio.post('/commissions', data: data);
    return CommissionModel.fromJson(res.data);
  }

  @override
  Future<CommissionModel> updateCommission(
      int id, Map<String, dynamic> data) async {
    final res = await _dio.put('/commissions/$id', data: data);
    return CommissionModel.fromJson(res.data);
  }

  @override
  Future<void> toggleCommission(int id) async {
    await _dio.patch('/commissions/$id/toggle');
  }
}