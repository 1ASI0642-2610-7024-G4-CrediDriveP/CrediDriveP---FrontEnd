import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/usecases/get_dashboard_summary_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetDashboardSummaryUsecase _getDashboardSummary;
  final FlutterSecureStorage _storage;

  HomeCubit(this._getDashboardSummary, this._storage)
      : super(const HomeInitial());

  Future<void> load() async {
    emit(const HomeLoading());
    final userName = await _storage.read(key: kUserNameKey) ?? 'Gestor';
    final result = await _getDashboardSummary();
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (summary) => emit(HomeLoaded(summary: summary, userName: userName)),
    );
  }

  Future<void> refresh() => load();
}