part of 'send_reset_code_cubit.dart';

@immutable
sealed class SendResetCodeState {}

final class SendResetCodeInitial extends SendResetCodeState {}

final class SendResetCodeLoading extends SendResetCodeState {}

final class SendResetCodeSuccess extends SendResetCodeState {
  final Map<String, dynamic> response;

  SendResetCodeSuccess({required this.response});
}

final class SendResetCodeFailure extends SendResetCodeState {
  final Map<String, dynamic> errorMessage;

  SendResetCodeFailure({required this.errorMessage});
}
