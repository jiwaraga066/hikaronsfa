part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileFailed extends ProfileState {
  final int statusCode;
  final String message;

  ProfileFailed({required this.statusCode, required this.message});
}

final class ProfileLoaded extends ProfileState {
  final int statusCode;
  final String message;
  final String username;
  final String email;
  final String foto;

  ProfileLoaded({required this.statusCode, required this.message, required this.username, required this.email, required this.foto});

}
