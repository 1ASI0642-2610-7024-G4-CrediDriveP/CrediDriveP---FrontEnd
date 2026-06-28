class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException({required this.message, this.statusCode});
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = 'No autorizado.']);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Error de conexión.']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Error de caché.']);
}
