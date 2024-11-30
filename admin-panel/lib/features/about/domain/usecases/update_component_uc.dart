import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/about/domain/repositories/about_repo.dart';
import 'package:conference_admin/features/pages/data/models/pages_model.dart';

class UpdateAboutPageUsecase extends UseCase<DataState<void>, PagesModel> {
  final AboutRepo aboutRepo;

  UpdateAboutPageUsecase(this.aboutRepo);

  @override
  Future<DataState<void>> call(PagesModel params) async {
    return await aboutRepo.updatePage(params);
  }
}
