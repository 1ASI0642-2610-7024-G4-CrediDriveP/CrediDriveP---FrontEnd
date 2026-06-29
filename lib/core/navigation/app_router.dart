import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/officer/home/presentation/pages/home_page.dart';
import '../../features/officer/solicitudes/presentation/pages/solicitudes_page.dart';
import '../../features/officer/solicitudes/presentation/pages/clients_page.dart';
import '../../features/officer/solicitudes/presentation/pages/vehicles_page.dart';
import '../../features/officer/simular/presentation/pages/simular_page.dart';
import '../../features/officer/creditos/presentation/pages/creditos_page.dart';
import '../../features/officer/creditos/presentation/pages/loan_detail_page.dart';
import '../../features/officer/configuracion/presentation/pages/configuracion_page.dart';
import '../../features/admin/dashboard/presentation/pages/admin_dashboard_page.dart';
import '../../features/admin/loans/presentation/pages/admin_loans_page.dart';
import '../../features/admin/insurances/presentation/pages/admin_insurances_page.dart';
import '../../features/admin/commissions/presentation/pages/admin_commissions_page.dart';
import '../../features/admin/officers/presentation/pages/admin_officers_page.dart';

import '../constants/app_constants.dart';

/// Rutas nombradas — úsalas con context.go(AppRoutes.login)
abstract class AppRoutes {
  // Rutas de officers
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
  // Rutas de administración (solo para usuarios con rol "admin")
  static const adminHome = '/admin';
  static const adminLoans = '/admin/loans';
  static const adminInsurances = '/admin/insurances';
  static const adminCommissions = '/admin/commissions';
  static const adminOfficers = '/admin/officers';
}

class AppRouter {
  static GoRouter create(FlutterSecureStorage storage) {
    return GoRouter(
      initialLocation: AppRoutes.login,
      redirect: (context, state) async {
        final token = await storage.read(key: kTokenKey);
        final role = await storage.read(key: kRoleKey);
        final loc = state.matchedLocation;
        final isAuth = loc == AppRoutes.login || loc == AppRoutes.register;

        // Si no está autenticado y no está en login/register, forzar login
        if (token == null && !isAuth) return AppRoutes.login;
        
        // Si ya está autenticado e intenta ir a login/register, redirigir según su rol
        if (token != null && isAuth) {
          return role == 'ADMIN' ? AppRoutes.adminHome : AppRoutes.home;
        }

        // Proteger rutas de administración
        if (loc.startsWith('/admin') && role != 'ADMIN') return AppRoutes.home;

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
        // Admin routes
        GoRoute(
          path: AppRoutes.adminHome,
          builder: (_, __) => const AdminDashboardPage(),
        ),
        GoRoute(
          path: AppRoutes.adminLoans,
          builder: (_, __) => const AdminLoansPage(),
        ),
        GoRoute(
          path: AppRoutes.adminInsurances,
          builder: (_, __) => const AdminInsurancesPage(),
        ),
        GoRoute(
          path: AppRoutes.adminCommissions,
          builder: (_, __) => const AdminCommissionsPage(),
        ),
        GoRoute(
          path: AppRoutes.adminOfficers,
          builder: (_, __) => const AdminOfficersPage(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Ruta no encontrada: ${state.uri}'),
        ),
      ),
    );
  }
}
