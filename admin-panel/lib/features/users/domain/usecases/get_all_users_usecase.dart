import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/login/data/models/admin_model.dart';
import 'package:conference_admin/features/users/domain/repositories/users_repo.dart';

class GetAllUsersUseCase extends UseCase<DataState<List<AdminModel>>, void> {
  final UsersRepo _usersRepo;

  GetAllUsersUseCase(this._usersRepo);

  @override
  Future<DataState<List<AdminModel>>> call(void params) async {
    return await _usersRepo.getAllUsers();
  }
}
