import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/faq/data/models/faq_model.dart';

abstract class FaqRepo {
  Future<DataState<FaqModel>> getReviewProcess();
  Future<DataState<FaqModel>> getSubmissionGuidelines();
  Future<DataState<void>> addReviewProcess(FaqModel faq);
  Future<DataState<void>> addSubmissionGuidelines(FaqModel faq);
  Future<DataState<void>> updateReviewProcess(FaqModel faq);
  Future<DataState<void>> updateSubmissionGuidelines(FaqModel faq);
}
