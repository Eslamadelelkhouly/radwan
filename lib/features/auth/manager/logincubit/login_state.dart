part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final LoginSuccessModel loginSuccessModel;

  LoginSuccess({required this.loginSuccessModel});
} 

final class LoginError extends LoginState {
  final Map<String, dynamic> errorMessage;

  LoginError({required this.errorMessage});
}
