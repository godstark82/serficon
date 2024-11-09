part of 'faq_bloc.dart';

abstract class FaqState extends Equatable {
  const FaqState();

  @override
  List<Object> get props => [];
}

class FaqInitial extends FaqState {}

class ReviewProcessLoading extends FaqState {}

class ReviewProcessLoaded extends FaqState {
  final FaqModel faqModel;

  const ReviewProcessLoaded({required this.faqModel});
}

class ReviewProcessError extends FaqState {
  final String message;

  const ReviewProcessError({required this.message});
}

class SubmissionProcessLoading extends FaqState {}

class SubmissionProcessLoaded extends FaqState {
  final FaqModel faqModel;

  const SubmissionProcessLoaded({required this.faqModel});
}

class SubmissionProcessError extends FaqState {
  final String message;

  const SubmissionProcessError({required this.message});
}
