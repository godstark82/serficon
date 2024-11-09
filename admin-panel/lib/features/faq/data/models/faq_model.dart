import 'package:conference_admin/features/faq/domain/entities/faq_entity.dart';

class FaqModel extends FaqEntity {
  const FaqModel(
      {required super.id,
      required super.questions,
      required super.description});

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
        id: json['id'],
        questions: FaqQuestionModel.fromJsonList(json['questions']),
        description: json['description']);
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questions': questions.map((question) => question.toModel().toJson()),
      'description': description
    };
  }

  // copyWith
  FaqModel copyWith({
    String? id,
    List<FaqQuestionModel>? questions,
    String? description,
  }) {
    return FaqModel(
        id: id ?? this.id,
        questions: questions ?? this.questions,
        description: description ?? this.description);
  }
}

class FaqQuestionModel extends FaqQuestionEntity {
  const FaqQuestionModel({required super.question, required super.answer});

  factory FaqQuestionModel.fromJson(Map<String, dynamic> json) {
    return FaqQuestionModel(question: json['question'], answer: json['answer']);
  }

  // list of FaqQuestionModel from json
  static List<FaqQuestionModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => FaqQuestionModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {'question': question, 'answer': answer};
  }

  // copyWith
  FaqQuestionModel copyWith({
    String? question,
    String? answer,
  }) {
    return FaqQuestionModel(
        question: question ?? this.question, answer: answer ?? this.answer);
  }
}
