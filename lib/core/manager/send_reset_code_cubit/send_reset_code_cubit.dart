import 'package:bloc/bloc.dart';
import 'package:diagnosify_app/core/API/api_service.dart';
import 'package:diagnosify_app/core/services/send_reset_code_services/send_reset_code_repo_implementation.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'send_reset_code_state.dart';

class SendResetCodeCubit extends Cubit<SendResetCodeState> {
  ApiService apiService = ApiService(dio: Dio());
  SendResetCodeCubit() : super(SendResetCodeInitial());

  Future<void> sendResetCode({required String email}) async {
    emit(SendResetCodeLoading());
    var result = await SendResetCodeRepoImplementation(apiService: apiService)
        .sendResetCode(email: email);

    result.fold(
      (error) {
        emit(SendResetCodeFailure(errorMessage: error));
      },
      (response) {
        emit(SendResetCodeSuccess(response: response));
      },
    );
  }
}
