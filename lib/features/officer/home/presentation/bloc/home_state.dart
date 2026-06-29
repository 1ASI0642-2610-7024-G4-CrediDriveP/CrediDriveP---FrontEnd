part of 'home_cubit.dart';


abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final DashboardSummary summary;
  final String userName;
  const HomeLoaded({required this.summary, required this.userName});
  @override
  List<Object?> get props => [summary, userName];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}