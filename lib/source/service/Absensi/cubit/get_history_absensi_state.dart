part of 'get_history_absensi_cubit.dart';

@immutable
sealed class GetHistoryAbsensiState {}

final class GetHistoryAbsensiInitial extends GetHistoryAbsensiState {}

final class GetHistoryAbsensiLoading extends GetHistoryAbsensiState {}

final class GetHistoryAbsensiLoaded extends GetHistoryAbsensiState {
  final int statusCode;
  final String message;
  final List<ModelHistoryAbsensi> model;

  GetHistoryAbsensiLoaded({required this.statusCode, required this.message, required this.model});
}

final class GetHistoryAbsensiFailed extends GetHistoryAbsensiState {
  final int statusCode;
  final String message;

  GetHistoryAbsensiFailed({required this.statusCode, required this.message});
}
