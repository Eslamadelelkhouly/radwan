part of 'get_profile_cubit.dart';

@immutable
sealed class GetProfileState {}

final class GetProfileInitial extends GetProfileState {}

final class GetProfileLoading extends GetProfileState {}

final class GetProfileError extends GetProfileState {
  final Map<String, dynamic> error;
  GetProfileError({required this.error});
}

final class GetProfileSuccess extends GetProfileState {
  final Map<String, dynamic> response;
  GetProfileSuccess({required this.response});
}

