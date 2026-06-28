import 'package:dio/dio.dart';
import '../models/auth_user_model.dart';

abstract class AuthRemoteDatasource {
  /// POST /api/auth/login
  Future<AuthUserModel> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio _dio;
  AuthRemoteDatasourceImpl(this._dio);

  @override
  Future<AuthUserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return AuthUserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
