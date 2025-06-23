import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:diagnosify_app/core/API/api_service.dart';
import 'package:diagnosify_app/core/services/question_services/model/question_model.dart';
import 'package:diagnosify_app/core/services/question_services/question_repo_implementaion.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'get_question_state.dart';

class GetQuestionCubit extends Cubit<GetQuestionState> {
  ApiService apiService = ApiService(dio: Dio());
  GetQuestionCubit() : super(GetQuestionInitial());

  Future<void> getQestions() async {
    emit(GetQuestionLoading());
    var result = await QuestionRepoImplementaion(apiService: apiService)
        .getQuestions();
    result.fold(
      (error) {
        emit(GetQuestionFailure(errorMessage: error));
      },
      (questionModel) {
        emit(GetQuestionSuccess(questionModel: questionModel));
      },
    );
  }
}
