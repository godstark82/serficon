import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/home/data/models/home_models_others.dart';
import 'package:conference_admin/features/home/domain/repositories/home_repo.dart';

class UpdatePublicationUseCase
    extends UseCase<DataState<void>, HomePublicationModel> {
  final HomeRepo homeRepo;

  UpdatePublicationUseCase(this.homeRepo);

  @override
  Future<DataState<void>> call(HomePublicationModel params) async {
    return await homeRepo.updatePublication(params);
  }
}
