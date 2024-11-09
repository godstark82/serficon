import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/login/data/models/admin_model.dart';
import 'package:conference_admin/features/users/domain/repositories/users_repo.dart';

class GetSpecificUserUsecase extends UseCase<DataState<AdminModel?>, String> {
  final UsersRepo _usersRepo;

  GetSpecificUserUsecase(this._usersRepo);

  @override
  Future<DataState<AdminModel?>> call(String params) async {
    return await _usersRepo.getUserInfo(params);
  }
}
