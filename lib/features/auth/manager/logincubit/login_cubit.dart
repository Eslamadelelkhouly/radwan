import 'package:bloc/bloc.dart';
import 'package:diagnosify_app/core/API/api_service.dart';
import 'package:diagnosify_app/features/auth/data/model/login_model.dart';
import 'package:diagnosify_app/features/auth/data/repo/auth_repo_implementation.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  ApiService apiService = ApiService(dio: Dio());

  Future<void> loginMethodCubit({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    var response = await AuthRepoImplementation(apiService: apiService)
        .logIn(email: email, password: password);
    response.fold(
      (error) {
        emit(LoginError(errorMessage: error));
      },
      (success) {
        emit(LoginSuccess(loginSuccessModel: success));
      },
    );
  }
}
