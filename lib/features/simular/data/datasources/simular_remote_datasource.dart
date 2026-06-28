import 'package:dio/dio.dart';
import '../models/simulation_model.dart';

abstract class SimularRemoteDatasource {
  Future<List<SimulationSummaryModel>> getSimulations();
  Future<SimulationModel> getSimulation(int id);
  Future<SimulationModel> createSimulation(Map<String, dynamic> data);
  Future<void> deleteSimulation(int id);
  Future<void> convertToLoan(int id);
}

class SimularRemoteDatasourceImpl implements SimularRemoteDatasource {
  final Dio _dio;
  SimularRemoteDatasourceImpl(this._dio);

  @override
  Future<List<SimulationSummaryModel>> getSimulations() async {
    final res = await _dio.get('/simulations');
    return (res.data as List)
        .map((e) => SimulationSummaryModel.fromJson(e))
        .toList();
  }

  @override
  Future<SimulationModel> getSimulation(int id) async {
    final res = await _dio.get('/simulations/$id');
    return SimulationModel.fromJson(res.data);
  }

  @override
  Future<SimulationModel> createSimulation(Map<String, dynamic> data) async {
    final res = await _dio.post('/simulations', data: data);
    return SimulationModel.fromJson(res.data);
  }

  @override
  Future<void> deleteSimulation(int id) async {
    await _dio.delete('/simulations/$id');
  }

  @override
  Future<void> convertToLoan(int id) async {
    await _dio.post('/simulations/$id/convert');
  }
}