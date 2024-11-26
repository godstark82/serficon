import 'package:conference_admin/core/const/no_params.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/home/data/models/home_component_model.dart';
import 'package:conference_admin/features/home/domain/repositories/home_repo.dart';

class GetHomeComponentsUsecase
    extends UseCase<DataState<List<HomeComponentModel>>, NoParams> {
  final HomeRepo homeRepo;

  GetHomeComponentsUsecase(this.homeRepo);

  @override
  Future<DataState<List<HomeComponentModel>>> call(NoParams params) async {
    return await homeRepo.getHomeComponents();
  }
}
