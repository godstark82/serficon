import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/faq/data/models/faq_model.dart';
import 'package:conference_admin/features/faq/domain/repositories/faq_repo.dart';

class GetSubmissionUseCase extends UseCase<DataState<FaqModel>, void> {
  final FaqRepo repo;

  GetSubmissionUseCase(this.repo);

  @override
  Future<DataState<FaqModel>> call(void params) async =>
      repo.getSubmissionGuidelines();
}
