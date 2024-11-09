import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/login/data/models/admin_model.dart';
import 'package:conference_admin/features/users/domain/repositories/users_repo.dart';
import 'package:conference_admin/core/services/users_service.dart';

class UsersRepoImpl implements UsersRepo {
  final UsersService _usersService;

  UsersRepoImpl(this._usersService);

  @override
  Future<DataState<List<AdminModel>>> getAllUsers() async {
    return await _usersService.getAllUsers();
  }

  @override
  Future<DataState<AdminModel?>> getUserInfo(String userId) async {
    return await _usersService.getUserInfo(userId);
  }
}
