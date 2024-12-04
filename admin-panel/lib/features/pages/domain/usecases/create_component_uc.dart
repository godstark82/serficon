import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/pages/domain/repositories/about_repo.dart';
import 'package:conference_admin/features/pages/data/models/page_model.dart';
class CreateAboutPageUsecase extends UseCase<DataState<void>, PagesModel> {
  final AboutRepo aboutRepo;

  CreateAboutPageUsecase(this.aboutRepo);

  @override
  Future<DataState<void>> call(PagesModel params) async {
    return await aboutRepo.createPage(params);
  }
}
