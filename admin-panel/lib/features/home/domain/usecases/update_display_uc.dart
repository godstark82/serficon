import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/home/domain/repositories/home_repo.dart';

class UpdateDisplayUsecase
    extends UseCase<DataState<void>, Map<String, dynamic>> {
  final HomeRepo homeRepo;

  UpdateDisplayUsecase(this.homeRepo);

  @override
  Future<DataState<void>> call(Map<String, dynamic> params) async {
    return await homeRepo.updateDisplay(params['id'], params['display']);
  }
}
