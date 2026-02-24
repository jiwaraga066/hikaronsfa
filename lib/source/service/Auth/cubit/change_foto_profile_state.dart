part of 'change_foto_profile_cubit.dart';

@immutable
sealed class ChangeFotoProfileState {}

final class ChangeFotoProfileInitial extends ChangeFotoProfileState {}

final class ChangeFotoProfileLoading extends ChangeFotoProfileState {}

final class ChangeFotoProfileLoaded extends ChangeFotoProfileState {
  final int statusCode;
  final String message;

  ChangeFotoProfileLoaded({required this.statusCode, required this.message});
}

final class ChangeFotoProfileFailed extends ChangeFotoProfileState {
  final int statusCode;
  final String message;

  ChangeFotoProfileFailed({required this.statusCode, required this.message});

}
