class AnswerModel {
  final int id;
  final int questionId;
  final String answer;
  final DateTime createdAt;
  final DateTime updatedAt;

  AnswerModel({
    required this.id,
    required this.questionId,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'] ?? 0,
      questionId: json['question_id'] ?? 0,
      answer: json['answer'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'answer': answer,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class QuestionModel {
  final int id;
  final String name;
  final String type;
  final List<AnswerModel> answers;

  QuestionModel({
    required this.id,
    required this.name,
    required this.type,
    required this.answers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final List<AnswerModel> answersList = (json['answers'] as List<dynamic>?)
            ?.map((e) => AnswerModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return QuestionModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      answers: answersList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }
}

List<QuestionModel> questionModelListFromJson(List<Map<String, dynamic>> data) {
  return data.map((item) => QuestionModel.fromJson(item)).toList();
}
