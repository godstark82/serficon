import 'package:bloc/bloc.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/faq/data/models/faq_model.dart';
import 'package:conference_admin/features/faq/domain/usecases/add_review_uc.dart';
import 'package:conference_admin/features/faq/domain/usecases/add_submission_uc.dart';
import 'package:conference_admin/features/faq/domain/usecases/get_review_uc.dart';
import 'package:conference_admin/features/faq/domain/usecases/get_submission_uc.dart';
import 'package:conference_admin/features/faq/domain/usecases/update_review_uc.dart';
import 'package:conference_admin/features/faq/domain/usecases/update_submission_uc.dart';
import 'package:equatable/equatable.dart';

part 'faq_event.dart';
part 'faq_state.dart';

class FaqBloc extends Bloc<FaqEvent, FaqState> {
  final GetReviewUseCase getReviewProcessUseCase;
  final AddReviewUseCase addReviewUseCase;
  final UpdateReviewUseCase updateReviewUseCase;
  final GetSubmissionUseCase getSubmissionProcessUseCase;
  final AddSubmissionUseCase addSubmissionUseCase;
  final UpdateSubmissionUseCase updateSubmissionUseCase;

  FaqBloc(
      this.getReviewProcessUseCase,
      this.addReviewUseCase,
      this.updateReviewUseCase,
      this.getSubmissionProcessUseCase,
      this.addSubmissionUseCase,
      this.updateSubmissionUseCase)
      : super(FaqInitial()) {
    //
    on<GetReviewProcessEvent>(_onGetReviewProcessEvent);
    on<UpdateReviewProcessEvent>(_onUpdateReviewProcessEvent);
    on<GetSubmissionProcessEvent>(_onGetSubmissionProcessEvent);
    on<UpdateSubmissionProcessEvent>(_onUpdateSubmissionProcessEvent);
  }

  Future<void> _onGetReviewProcessEvent(
      GetReviewProcessEvent event, Emitter<FaqState> emit) async {
    emit(ReviewProcessLoading());
    final result = await getReviewProcessUseCase.call(null);
    if (result is DataSuccess) {
      emit(ReviewProcessLoaded(faqModel: result.data!));
    } else if (result is DataFailed) {
      emit(ReviewProcessError(message: result.message ?? 'Some Error Occured'));
    }
  }

  Future<void> _onUpdateReviewProcessEvent(
      UpdateReviewProcessEvent event, Emitter<FaqState> emit) async {
    emit(ReviewProcessLoading());
    final result = await updateReviewUseCase.call(event.faqModel);
    //
    if (result is DataFailed) {
      emit(ReviewProcessError(message: result.message ?? 'Some Error Occured'));
    }
    add(GetReviewProcessEvent());
  }

  Future<void> _onGetSubmissionProcessEvent(
      GetSubmissionProcessEvent event, Emitter<FaqState> emit) async {
    //
    emit(SubmissionProcessLoading());
    final result = await getSubmissionProcessUseCase.call(null);
    if (result is DataSuccess) {
      emit(SubmissionProcessLoaded(faqModel: result.data!));
    } else if (result is DataFailed) {
      emit(SubmissionProcessError(
          message: result.message ?? 'Some Error Occured'));
    }
  }

  Future<void> _onUpdateSubmissionProcessEvent(
      UpdateSubmissionProcessEvent event, Emitter<FaqState> emit) async {
    //
    emit(SubmissionProcessLoading());
    final result = await updateSubmissionUseCase.call(event.faqModel);
    if (result is DataFailed) {
      emit(SubmissionProcessError(
          message: result.message ?? 'Some Error Occured'));
    }
    add(GetSubmissionProcessEvent());
  }
}
