import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/solicitudes/presentation/pages/solicitudes_page.dart';
import '../../features/solicitudes/presentation/pages/clients_page.dart';
import '../../features/solicitudes/presentation/pages/vehicles_page.dart';
import '../../features/simular/presentation/pages/simular_page.dart';
import '../../features/creditos/presentation/pages/creditos_page.dart';
import '../../features/creditos/presentation/pages/loan_detail_page.dart';
import '../../features/configuracion/presentation/pages/configuracion_page.dart';

import '../constants/app_constants.dart';

/// Rutas nombradas — úsalas con context.go(AppRoutes.login)
abstract class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/';
  static const solicitudes = '/solicitudes';
  static const solicitudesClientes = '/solicitudes/clientes';
  static const solicitudesVehiculos = '/solicitudes/vehiculos';
  static const solicitudesUsuarios = '/solicitudes/usuarios';
  static const simular = '/simular';
  static const creditos = '/creditos';
  static const creditoDetalle = '/creditos/:id';
  static const configuracion = '/configuracion';
}

class AppRouter {
  static GoRouter create(FlutterSecureStorage storage) {
    return GoRouter(
      initialLocation: AppRoutes.login,
      redirect: (context, state) async {
        final token = await storage.read(key: kTokenKey);
        final isLoggingIn = state.matchedLocation == AppRoutes.login ||
            state.matchedLocation == AppRoutes.register;

        if (token == null && !isLoggingIn) return AppRoutes.login;
        if (token != null && isLoggingIn) return AppRoutes.home;
        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoutes.register,
          name: 'register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppRoutes.solicitudes,
          name: 'solicitudes',
          builder: (context, state) => const SolicitudesPage(),
        ),
        GoRoute(
          path: AppRoutes.solicitudesClientes,
          name: 'clientes',
          builder: (context, state) => const ClientsPage(),
        ),
        GoRoute(
          path: AppRoutes.solicitudesVehiculos,
          name: 'vehiculos',
          builder: (context, state) => const VehiclesPage(),
        ),
        GoRoute(
          path: AppRoutes.simular,
          name: 'simular',
          builder: (context, state) => const SimularPage(),
        ),
        GoRoute(
          path: AppRoutes.creditos,
          name: 'creditos',
          builder: (context, state) => const CreditosPage(),
        ),
        GoRoute(
          path: AppRoutes.creditoDetalle,
          name: 'creditoDetalle',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return LoanDetailPage(loanId: id);
          },
        ),
        GoRoute(
          path: AppRoutes.configuracion,
          name: 'configuracion',
          builder: (context, state) => const ConfiguracionPage(),
        ),
        // TODO: Agregar rutas de solicitudes, simular, créditos, configuración
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Ruta no encontrada: ${state.uri}'),
        ),
      ),
    );
  }
}
