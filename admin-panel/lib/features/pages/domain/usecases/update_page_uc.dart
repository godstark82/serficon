import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/pages/data/models/pages_model.dart';
import 'package:conference_admin/features/pages/domain/repositories/page_repo.dart';

class UpdatePageUseCase extends UseCase<DataState<void>, PagesModel> {
  final PageRepo repo;

  UpdatePageUseCase(this.repo);

  @override
  Future<DataState<void>> call(PagesModel params) async {
    return await repo.updatePage(params);
  }
}
