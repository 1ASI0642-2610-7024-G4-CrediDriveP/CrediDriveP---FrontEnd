import 'package:dio/dio.dart';
import '../models/client_model.dart';
import '../models/vehicle_model.dart';

abstract class SolicitudesRemoteDatasource {
  Future<List<ClientModel>> getClients();
  Future<ClientModel> getClient(int id);
  Future<ClientModel> createClient(Map<String, dynamic> data);
  Future<ClientModel> updateClient(int id, Map<String, dynamic> data);
  Future<void> deleteClient(int id);

  Future<List<VehicleModel>> getVehicles({String? status, String? brand});
  Future<VehicleModel> getVehicle(int id);
  Future<VehicleModel> createVehicle(Map<String, dynamic> data);
  Future<VehicleModel> updateVehicle(int id, Map<String, dynamic> data);
  Future<void> deleteVehicle(int id);
}

class SolicitudesRemoteDatasourceImpl implements SolicitudesRemoteDatasource {
  final Dio _dio;
  SolicitudesRemoteDatasourceImpl(this._dio);

  // ── Clientes ────────────────────────────────────────────────────────────

  @override
  Future<List<ClientModel>> getClients() async {
    final res = await _dio.get('/clients');
    return (res.data as List).map((e) => ClientModel.fromJson(e)).toList();
  }

  @override
  Future<ClientModel> getClient(int id) async {
    final res = await _dio.get('/clients/$id');
    return ClientModel.fromJson(res.data);
  }

  @override
  Future<ClientModel> createClient(Map<String, dynamic> data) async {
    final res = await _dio.post('/clients', data: data);
    return ClientModel.fromJson(res.data);
  }

  @override
  Future<ClientModel> updateClient(int id, Map<String, dynamic> data) async {
    final res = await _dio.put('/clients/$id', data: data);
    return ClientModel.fromJson(res.data);
  }

  @override
  Future<void> deleteClient(int id) async {
    await _dio.delete('/clients/$id');
  }

  // ── Vehículos ───────────────────────────────────────────────────────────

  @override
  Future<List<VehicleModel>> getVehicles({String? status, String? brand}) async {
    final res = await _dio.get(
      '/vehicles',
      queryParameters: {
        if (status != null) 'status': status,
        if (brand != null) 'brand': brand,
      },
    );
    return (res.data as List).map((e) => VehicleModel.fromJson(e)).toList();
  }

  @override
  Future<VehicleModel> getVehicle(int id) async {
    final res = await _dio.get('/vehicles/$id');
    return VehicleModel.fromJson(res.data);
  }

  @override
  Future<VehicleModel> createVehicle(Map<String, dynamic> data) async {
    final res = await _dio.post('/vehicles', data: data);
    return VehicleModel.fromJson(res.data);
  }

  @override
  Future<VehicleModel> updateVehicle(int id, Map<String, dynamic> data) async {
    final res = await _dio.put('/vehicles/$id', data: data);
    return VehicleModel.fromJson(res.data);
  }

  @override
  Future<void> deleteVehicle(int id) async {
    await _dio.delete('/vehicles/$id');
  }
}