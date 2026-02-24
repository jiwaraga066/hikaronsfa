part of 'change_password_cubit.dart';

@immutable
sealed class ChangePasswordState {}

final class ChangePasswordInitial extends ChangePasswordState {}

final class ChangePasswordLoading extends ChangePasswordState {}

final class ChangePasswordLoaded extends ChangePasswordState {
  final int statusCode;
  final String message;

  ChangePasswordLoaded({required this.statusCode, required this.message});
}

final class ChangePasswordFailed extends ChangePasswordState {
  final int statusCode;
  final String message;

  ChangePasswordFailed({required this.statusCode, required this.message});
}
