import 'package:dio/dio.dart';
import '../models/dashboard_summary_model.dart';

abstract class HomeRemoteDatasource {
  Future<DashboardSummaryModel> getDashboardSummary();
}

class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final Dio _dio;
  HomeRemoteDatasourceImpl(this._dio);

  @override
  Future<DashboardSummaryModel> getDashboardSummary() async {
    final response = await _dio.get('/dashboard/summary');
    return DashboardSummaryModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}