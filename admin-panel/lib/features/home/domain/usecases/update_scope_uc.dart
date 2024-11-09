import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/home/data/models/home_models_others.dart';
import 'package:conference_admin/features/home/domain/repositories/home_repo.dart';

class UpdateScopeUseCase
    extends UseCase<DataState<void>, HomeCongressScopeModel> {
  final HomeRepo homeRepo;

  UpdateScopeUseCase(this.homeRepo);

  @override
  Future<DataState<void>> call(HomeCongressScopeModel params) async {
    return await homeRepo.updateCongressScope(params);
  }
}
