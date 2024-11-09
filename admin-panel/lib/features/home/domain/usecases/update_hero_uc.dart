
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/home/data/models/home_models_others.dart';
import 'package:conference_admin/features/home/domain/repositories/home_repo.dart';

class UpdateHeroUseCase extends UseCase<DataState<void>, HomeHeroModel> {
  final HomeRepo homeRepo;

  UpdateHeroUseCase(this.homeRepo);

  @override
  Future<DataState<void>> call(HomeHeroModel params) async {
    return await homeRepo.updateHero(params);
  }
}
