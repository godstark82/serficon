import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/home/data/models/home_models_others.dart';
import 'package:conference_admin/features/home/domain/repositories/home_repo.dart';

class UpdateWelcomeUseCase
    extends UseCase<DataState<void>, HomePresidentWelcomeModel> {
  final HomeRepo homeRepo;

  UpdateWelcomeUseCase(this.homeRepo);

  @override
  Future<DataState<void>> call(HomePresidentWelcomeModel params) async {
    return await homeRepo.updatePresidentWelcome(params);
  }
}
