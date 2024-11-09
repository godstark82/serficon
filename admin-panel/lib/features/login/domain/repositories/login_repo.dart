import 'package:conference_admin/features/login/data/repositories/login_repo_impl.dart';

abstract class LoginRepo {

  Future loginUser(EmailPassModel emailPass);

  Future<void> logOut();
}
