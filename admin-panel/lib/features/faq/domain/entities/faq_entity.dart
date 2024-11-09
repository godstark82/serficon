import 'package:conference_admin/features/faq/data/models/faq_model.dart';
import 'package:equatable/equatable.dart';

class FaqEntity extends Equatable {
  final String id;
  final List<FaqQuestionEntity> questions;
  final String description;

  const FaqEntity(
      {required this.id, required this.questions, required this.description});

  @override
  List<Object?> get props => [id, questions, description];
}

class FaqQuestionEntity extends Equatable {
  final String question;
  final String answer;

  const FaqQuestionEntity({required this.question, required this.answer});

  // toModel
  FaqQuestionModel toModel() {
    return FaqQuestionModel(question: question, answer: answer);
  }

  @override
  List<Object?> get props => [question, answer];
}
