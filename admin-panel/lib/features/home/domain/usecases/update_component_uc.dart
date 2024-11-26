import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/home/data/models/home_component_model.dart';
import 'package:conference_admin/features/home/domain/repositories/home_repo.dart';

class UpdateComponentUsecase
    extends UseCase<DataState<void>, HomeComponentModel> {
  final HomeRepo homeRepo;

  UpdateComponentUsecase(this.homeRepo);

  @override
  Future<DataState<void>> call(HomeComponentModel params) async {
    return await homeRepo.updateHomeComponent(params);
  }
}
