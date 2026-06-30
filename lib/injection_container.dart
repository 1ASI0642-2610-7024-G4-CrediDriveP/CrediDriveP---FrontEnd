import 'package:credidrivep/features/officer/home/data/datasources/home_remote_datasource.dart';
import 'package:credidrivep/features/officer/home/data/repositories/home_repository_impl.dart';
import 'package:credidrivep/features/officer/home/domain/repositories/home_repository.dart';
import 'package:credidrivep/features/officer/home/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:credidrivep/features/officer/home/presentation/bloc/home_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/api/dio_client.dart';

// Auth
import 'features/admin/loan_plans/presentation/bloc/loan_plans_cubit.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/bloc/login_cubit.dart';
import 'features/auth/presentation/bloc/register_cubit.dart';

import 'features/officer/solicitudes/data/datasources/solicitudes_remote_datasource.dart';
import 'features/officer/solicitudes/data/repositories/solicitudes_repository_impl.dart';
import 'features/officer/solicitudes/domain/repositories/solicitudes_repository.dart';
import 'features/officer/solicitudes/domain/usecases/client_usecases.dart';
import 'features/officer/solicitudes/domain/usecases/vehicle_usecases.dart';
import 'features/officer/solicitudes/presentation/bloc/clients_cubit.dart';
import 'features/officer/solicitudes/presentation/bloc/vehicles_cubit.dart';
import 'features/officer/simular/data/datasources/simular_remote_datasource.dart';
import 'features/officer/simular/data/repositories/simular_repository_impl.dart';
import 'features/officer/simular/domain/repositories/simular_repository.dart';
import 'features/officer/simular/domain/usecases/simulation_usecases.dart';
import 'features/officer/simular/presentation/bloc/simular_cubit.dart';
import 'features/officer/creditos/data/datasources/creditos_remote_datasource.dart';
import 'features/officer/creditos/data/repositories/creditos_repository_impl.dart';
import 'features/officer/creditos/domain/repositories/creditos_repository.dart';
import 'features/officer/creditos/domain/usecases/loan_usecases.dart';
import 'features/officer/creditos/presentation/bloc/creditos_cubit.dart';
import 'features/officer/configuracion/data/datasources/configuracion_remote_datasource.dart';
import 'features/officer/configuracion/data/repositories/configuracion_repository_impl.dart';
import 'features/officer/configuracion/domain/repositories/configuracion_repository.dart';
import 'features/officer/configuracion/domain/usecases/configuracion_usecases.dart';
import 'features/officer/configuracion/presentation/bloc/configuracion_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── Core ──────────────────────────────────────────────────────────────────
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  sl.registerLazySingleton<FlutterSecureStorage>(() => storage);
  sl.registerLazySingleton<DioClient>(() => DioClient(sl()));

  // ── Auth ──────────────────────────────────────────────────────────────────
  // Datasources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl<DioClient>().dio),
  );
  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDatasource: sl(),
      storage: sl(),
    ),
  );
  // Usecases
  sl.registerLazySingleton(() => LoginUsecase(sl()));

  // Cubits (factory → nueva instancia cada vez)
  sl.registerFactory(() => LoginCubit(sl()));
  sl.registerFactory(() => RegisterCubit(sl()));

  // ── Home ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<HomeRemoteDatasource>(
    () => HomeRemoteDatasourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton(() => GetDashboardSummaryUsecase(sl()));
  sl.registerFactory(() => HomeCubit(sl(), sl()));

  // ── Solicitudes ───────────────────────────────────────────────────────────
  sl.registerLazySingleton<SolicitudesRemoteDatasource>(
    () => SolicitudesRemoteDatasourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<SolicitudesRepository>(
    () => SolicitudesRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton(() => GetClientsUsecase(sl()));
  sl.registerLazySingleton(() => CreateClientUsecase(sl()));
  sl.registerLazySingleton(() => UpdateClientUsecase(sl()));
  sl.registerLazySingleton(() => DeleteClientUsecase(sl()));
  sl.registerLazySingleton(() => GetVehiclesUsecase(sl()));
  sl.registerLazySingleton(() => CreateVehicleUsecase(sl()));
  sl.registerLazySingleton(() => UpdateVehicleUsecase(sl()));
  sl.registerLazySingleton(() => DeleteVehicleUsecase(sl()));
  sl.registerFactory(() => ClientsCubit(
        getClients: sl(),
        createClient: sl(),
        updateClient: sl(),
        deleteClient: sl(),
      ));
  sl.registerFactory(() => VehiclesCubit(
        getVehicles: sl(),
        createVehicle: sl(),
        updateVehicle: sl(),
        deleteVehicle: sl(),
  ));

  // ── Simular ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<SimularRemoteDatasource>(
    () => SimularRemoteDatasourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<SimularRepository>(
    () => SimularRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton(() => GetSimulationsUsecase(sl()));
  sl.registerLazySingleton(() => GetSimulationUsecase(sl()));
  sl.registerLazySingleton(() => CreateSimulationUsecase(sl()));
  sl.registerLazySingleton(() => DeleteSimulationUsecase(sl()));
  sl.registerLazySingleton(() => ConvertToLoanUsecase(sl()));
  sl.registerFactory(() => SimularCubit(create: sl(), convert: sl()));
  sl.registerFactory(() => HistorialCubit(
        getSimulations: sl(),
        delete: sl(),
      ));


  // ── Créditos ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton<CreditosRemoteDatasource>(
    () => CreditosRemoteDatasourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<CreditosRepository>(
    () => CreditosRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton(() => GetLoansUsecase(sl()));
  sl.registerLazySingleton(() => GetLoanUsecase(sl()));
  sl.registerLazySingleton(() => UpdateLoanStatusUsecase(sl()));
  sl.registerFactory(() => CreditosCubit(getLoans: sl()));
  sl.registerFactory(() => LoanDetailCubit(
        getLoan: sl(),
        updateStatus: sl(),
      ));

  // ── Configuración ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<ConfiguracionRemoteDatasource>(
    () => ConfiguracionRemoteDatasourceImpl(sl<DioClient>().dio),
  );
  sl.registerLazySingleton<ConfiguracionRepository>(
    () => ConfiguracionRepositoryImpl(
      remoteDatasource: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetProfileUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerFactory(() => ConfiguracionCubit(
        getProfile: sl(),
        logout: sl(),
      ));
  sl.registerFactory(() => LoanPlansCubit(sl()));
  
}
