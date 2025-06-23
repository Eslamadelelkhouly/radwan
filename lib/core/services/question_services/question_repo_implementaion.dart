import 'package:dartz/dartz.dart';
import 'package:diagnosify_app/core/API/api_service.dart';
import 'package:diagnosify_app/core/API/backend_endpoint.dart';
import 'package:diagnosify_app/core/services/question_services/model/question_model.dart';
import 'package:diagnosify_app/core/services/question_services/question_repo.dart';
import 'package:dio/dio.dart';

class QuestionRepoImplementaion extends QuestionRepo {
  final ApiService apiService;

  QuestionRepoImplementaion({required this.apiService});

  @override
  Future<Either<Map<String, dynamic>, List<QuestionModel>>> getQuestions() async {
    try {
      var response = await apiService.Get(endpoint: BackendEndpoint.getQuestions);
      
      List<QuestionModel> questions = (response as List)
          .map((questionJson) => QuestionModel.fromJson(questionJson))
          .toList();

      return Right(questions);
    } catch (e) {
      if (e is DioException) {
        return Left({
          'error': e.message ?? 'An error occurred while fetching questions',
          'statusCode': e.response?.statusCode ?? 500,
        });
      } else {
        return Left({
          'error': e.toString(),
          'statusCode': 500,
        });
      }
    }
  }
}
