import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/home/domain/repositories/home_repo.dart';

class DeleteComponentUsecase
    extends UseCase<DataState<void>, String> {
  final HomeRepo homeRepo;

  DeleteComponentUsecase(this.homeRepo);

  @override
  Future<DataState<void>> call(String params) async {
    return await homeRepo.deleteHomeComponent(params);
  }
}
