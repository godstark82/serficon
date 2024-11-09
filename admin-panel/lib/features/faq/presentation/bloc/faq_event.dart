part of 'faq_bloc.dart';

abstract class FaqEvent extends Equatable {
  const FaqEvent();

  @override
  List<Object> get props => [];
}

class GetReviewProcessEvent extends FaqEvent {}

class GetSubmissionProcessEvent extends FaqEvent {}

class AddReviewProcessEvent extends FaqEvent {
  final FaqModel faqModel;

  const AddReviewProcessEvent({required this.faqModel});
}

class UpdateReviewProcessEvent extends FaqEvent {
  final FaqModel faqModel;

  const UpdateReviewProcessEvent({required this.faqModel});
}

class AddSubmissionProcessEvent extends FaqEvent {
  final FaqModel faqModel;

  const AddSubmissionProcessEvent({required this.faqModel});
}

class UpdateSubmissionProcessEvent extends FaqEvent {
  final FaqModel faqModel;

  const UpdateSubmissionProcessEvent({required this.faqModel});
}
  