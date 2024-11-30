import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/about/domain/repositories/about_repo.dart';

class DeleteAboutPageUsecase extends UseCase<DataState<void>, String> {
  final AboutRepo aboutRepo;

  DeleteAboutPageUsecase(this.aboutRepo);

  @override
  Future<DataState<void>> call(String params) async {
    return await aboutRepo.deletePage(params);
  }
}
