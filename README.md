# CrediDriveP — Frontend Flutter

Sistema de gestión de créditos vehiculares para Perú.

## Stack

| Capa | Tecnología |
|---|---|
| Framework | Flutter 3.19+ |
| Arquitectura | Clean Architecture (por feature) |
| Estado | BLoC / Cubit |
| DI | get_it |
| HTTP | Dio + interceptores JWT |
| Storage | flutter_secure_storage |
| Navegación | go_router |
| Programación funcional | dartz (Either) |

## Estructura

```
lib/
├── core/
│   ├── api/          # DioClient con interceptor JWT
│   ├── constants/    # URLs, keys de storage
│   ├── errors/       # Failures + Exceptions
│   ├── navigation/   # AppRouter (go_router)
│   └── theme/        # AppColors + AppTheme
├── features/
│   ├── auth/         # Login + Register
│   ├── home/         # Dashboard
│   ├── solicitudes/  # Clientes + Vehículos + Usuarios
│   ├── simular/      # Simulador de crédito
│   ├── creditos/     # Historial + Plan de pagos
│   └── configuracion/# Perfil + ajustes
└── injection_container.dart  # Service locator
```

## Configuración de URL

Edita `lib/core/constants/app_constants.dart` y descomenta la línea
que corresponda a tu entorno:

```dart
// Emulador Android
const String kBaseUrl = 'http://10.0.2.2:5298/api';

// Dispositivo físico (misma red Wi-Fi)
const String kBaseUrl = 'http://192.168.x.x:5298/api';

// Web / localhost
const String kBaseUrl = 'http://127.0.0.1:5298/api';   // ← activo

// Railway
const String kBaseUrl = 'https://tu-proyecto.up.railway.app/api';
```

## Correr con Docker

```bash
docker-compose up --build
# App disponible en http://localhost:5000
```

## Correr localmente

```bash
flutter pub get
flutter run
```

## Roles

| Rol | Email por defecto | Puede |
|---|---|---|
| ADMIN | admin@credidrivep.com | Todo: aprobar préstamos, gestionar officers |
| OFFICER | (creado por ADMIN) | Registrar clientes/vehículos, crear simulaciones |

## Orden de implementación

- [x] Estructura del proyecto + Docker
- [x] Core (DioClient, AppTheme, AppRouter, Failures)
- [x] Auth — Login + Register
- [ ] Home / Dashboard
- [ ] Solicitudes (Clientes, Vehículos, Usuarios)
- [ ] Simular crédito
- [ ] Créditos (Historial + Plan de pagos)
- [ ] Configuración / Perfil
