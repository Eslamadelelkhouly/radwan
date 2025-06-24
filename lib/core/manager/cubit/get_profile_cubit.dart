import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:diagnosify_app/core/API/api_service.dart';
import 'package:diagnosify_app/core/services/get_profile_info/get_profile_repo_implementation.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'get_profile_state.dart';

class GetProfileCubit extends Cubit<GetProfileState> {
  ApiService apiService = ApiService(dio: Dio());
  GetProfileCubit() : super(GetProfileInitial());
  Future<void> getProfile() async {
    emit(GetProfileLoading());
    final result = await GetProfileRepoImplementation(apiService: apiService)
        .getinfoProfile();

    result.fold(
      (error) {
        emit(GetProfileError(error: error));
      },
      (response) {
        emit(GetProfileSuccess(response: response));
      },
    );
  }
}
