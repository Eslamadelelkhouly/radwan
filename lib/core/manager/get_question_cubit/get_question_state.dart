part of 'get_question_cubit.dart';

@immutable
sealed class GetQuestionState {}

final class GetQuestionInitial extends GetQuestionState {}

final class GetQuestionLoading extends GetQuestionState {}

final class GetQuestionSuccess extends GetQuestionState {
  final List<QuestionModel> questionModel;

  GetQuestionSuccess({required this.questionModel});
}

final class GetQuestionFailure extends GetQuestionState {
  final Map<String, dynamic> errorMessage;

  GetQuestionFailure({required this.errorMessage});
}
