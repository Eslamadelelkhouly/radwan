import 'package:dartz/dartz.dart';
import 'package:diagnosify_app/core/services/question_services/model/question_model.dart';

abstract class QuestionRepo {
  Future<Either<Map<String, dynamic>, List<QuestionModel>>> getQuestions();
}
