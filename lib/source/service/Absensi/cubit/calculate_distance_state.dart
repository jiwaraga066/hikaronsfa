part of 'calculate_distance_cubit.dart';

@immutable
sealed class CalculateDistanceState {}

final class CalculateDistanceInitial extends CalculateDistanceState {}

final class CalculateDistanceLoading extends CalculateDistanceState {}

final class CalculateDistanceLoaded extends CalculateDistanceState {
  final double meterPlace;

  CalculateDistanceLoaded({required this.meterPlace});
}
