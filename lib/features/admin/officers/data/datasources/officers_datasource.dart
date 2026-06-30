import 'package:dio/dio.dart';
import '../models/officer_model.dart';

abstract class OfficersDatasource {
  Future<List<OfficerModel>> getOfficers();
  Future<OfficerModel> createOfficer(Map<String, dynamic> data);
  Future<OfficerModel> updateOfficer(int id, Map<String, dynamic> data);
  Future<void> toggleOfficer(int id);
  Future<void> resetPassword(int id, String newPassword);
}

class OfficersDatasourceImpl implements OfficersDatasource {
  final Dio _dio;
  OfficersDatasourceImpl(this._dio);

  @override
  Future<List<OfficerModel>> getOfficers() async {
    final res = await _dio.get('/auth/officers');
    return (res.data as List).map((e) => OfficerModel.fromJson(e)).toList();
  }

  @override
  Future<OfficerModel> createOfficer(Map<String, dynamic> data) async {
    final res = await _dio.post('/auth/officers', data: data);
    return OfficerModel.fromJson(res.data);
  }

  @override
  Future<OfficerModel> updateOfficer(int id, Map<String, dynamic> data) async {
    final res = await _dio.put('/auth/officers/$id', data: data);
    return OfficerModel.fromJson(res.data);
  }

  @override
  Future<void> toggleOfficer(int id) async {
    await _dio.patch('/auth/officers/$id/toggle');
  }

  @override
  Future<void> resetPassword(int id, String newPassword) async {
    await _dio.put('/auth/officers/$id/reset-password',
        data: {'newPassword': newPassword});
  }
}