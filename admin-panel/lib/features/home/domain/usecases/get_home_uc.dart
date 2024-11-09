import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/home/data/models/home_model.dart';
import 'package:conference_admin/features/home/domain/repositories/home_repo.dart';

class GetHomeUseCase extends UseCase<DataState<HomeModel>, void> {
  final HomeRepo homeRepo;

  GetHomeUseCase(this.homeRepo);

  @override
  Future<DataState<HomeModel>> call(void params) async {
    return await homeRepo.getHomeData();
  }
}
