import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

class DioClient {
  late final Dio _dio;
  final FlutterSecureStorage _storage;

  DioClient(this._storage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: kBaseUrl,
        connectTimeout: const Duration(seconds: kConnectTimeout),
        receiveTimeout: const Duration(seconds: kReceiveTimeout),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(_storage),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('[DIO] $obj'),
      ),
    ]);
  }

  Dio get dio => _dio;
}

/// Interceptor que añade el JWT a cada petición automáticamente
class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;

  _AuthInterceptor(this._storage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: kTokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        throw NetworkException('Tiempo de espera agotado.');
      case DioExceptionType.connectionError:
        throw NetworkException('Sin conexión a internet.');
      default:
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          throw UnauthorizedException();
        }
        final message = _extractMessage(err.response?.data) ??
            err.message ??
            'Error desconocido.';
        throw ServerException(message: message, statusCode: statusCode);
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map) {
      return data['message']?.toString() ??
          data['title']?.toString() ??
          data['error']?.toString();
    }
    return null;
  }
}
