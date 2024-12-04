import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/pages/domain/repositories/about_repo.dart';
import 'package:conference_admin/features/pages/data/models/page_model.dart';

class GetAboutPageByIdUsecase extends UseCase<DataState<PagesModel>, String> {
  final AboutRepo aboutRepo;

  GetAboutPageByIdUsecase(this.aboutRepo);

  @override
  Future<DataState<PagesModel>> call(String params) async {
    return await aboutRepo.getPage(params);
  }
}
