import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Error de red / conexión
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Sin conexión a internet.']);
}

/// Error de servidor (5xx)
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Error del servidor. Intenta más tarde.']);
}

/// 401 — token inválido o sesión expirada
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Sesión expirada. Inicia sesión nuevamente.']);
}

/// 403 — sin permiso
class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message = 'No tienes permiso para realizar esta acción.']);
}

/// 404 — recurso no encontrado
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Recurso no encontrado.']);
}

/// Error de validación (400)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Error local / caché
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Error al leer datos locales.']);
}
