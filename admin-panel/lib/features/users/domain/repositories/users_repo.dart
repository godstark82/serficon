import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/login/data/models/admin_model.dart';

abstract class UsersRepo {
  Future<DataState<List<AdminModel>>> getAllUsers();
  Future<DataState<AdminModel?>> getUserInfo(String userId);
}
