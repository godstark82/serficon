import 'package:conference_admin/core/const/no_params.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/pages/domain/repositories/about_repo.dart';
import 'package:conference_admin/features/pages/data/models/page_model.dart';

class GetAboutPagesUsecase extends UseCase<DataState<List<PagesModel>>, NoParams> {
  final AboutRepo aboutRepo;

  GetAboutPagesUsecase(this.aboutRepo);

  @override
  Future<DataState<List<PagesModel>>> call(NoParams params) async {
    return await aboutRepo.getPages();
  }
}

