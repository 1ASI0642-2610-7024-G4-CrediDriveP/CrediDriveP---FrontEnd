import 'package:dio/dio.dart';
import '../models/user_profile_model.dart';

abstract class ConfiguracionRemoteDatasource {
  /// GET /api/auth/me
  Future<UserProfileModel> getProfile();
}

class ConfiguracionRemoteDatasourceImpl
    implements ConfiguracionRemoteDatasource {
  final Dio _dio;
  ConfiguracionRemoteDatasourceImpl(this._dio);

  @override
  Future<UserProfileModel> getProfile() async {
    final res = await _dio.get('/auth/me');
    return UserProfileModel.fromJson(res.data as Map<String, dynamic>);
  }
}