import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/pages/data/models/pages_model.dart';
import 'package:conference_admin/features/pages/domain/repositories/page_repo.dart';

class GetPageUseCase extends UseCase<DataState<PagesModel>, String> {
  final PageRepo repo;

  GetPageUseCase(this.repo);
  @override
  Future<DataState<PagesModel>> call(String params) async {
    return await repo.getPage(params);
  }
}
