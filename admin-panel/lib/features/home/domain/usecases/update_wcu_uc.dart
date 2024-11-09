import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/home/data/models/home_models_others.dart';
import 'package:conference_admin/features/home/domain/repositories/home_repo.dart';

class UpdateWcuUseCase extends UseCase<DataState<void>, HomeWhyChooseUsModel> {
  final HomeRepo homeRepo;

  UpdateWcuUseCase(this.homeRepo);

  @override
  Future<DataState<void>> call(HomeWhyChooseUsModel params) async {
    return await homeRepo.updateWhyChooseUs(params);
  }
}
