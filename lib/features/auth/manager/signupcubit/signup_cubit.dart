import 'package:bloc/bloc.dart';
import 'package:diagnosify_app/core/API/api_service.dart';
import 'package:diagnosify_app/features/auth/data/model/signup_model.dart';
import 'package:diagnosify_app/features/auth/data/repo/auth_repo_implementation.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());
  final ApiService apiService = ApiService(dio: Dio());

  Future<void> Signupmethodcubit(
      {required String FName,
      required String LName,
      required String nationalid,
      required String phoneNumber,
      required String email,
      required String password,
      required String password_confirmation}) async {

    emit(SignupLoading());
    var response = await AuthRepoImplementation(apiService: apiService).signUp(
      FName: FName,
      LName: LName,
      nationalid: nationalid,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
      password_confirmation: password_confirmation,
    );
    response.fold(
      (error) {
        emit(SignupError(errorMessage: error));
      },
      (success) {
        emit(SignupSuccess(signUpModel: success));
      },
    );
  }
}
