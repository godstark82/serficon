
import 'package:conference_admin/features/login/domain/repositories/login_repo.dart';
import 'package:conference_admin/core/services/login/login_service.dart';

class LoginRepoImpl implements LoginRepo {
  LoginService loginService;
  LoginRepoImpl(this.loginService);

  @override
  Future loginUser(EmailPassModel emailPass) async {
    final user = await loginService.signIn(emailPass.email, emailPass.password);
    return user;
  }

  @override
  Future<void> logOut() async {
    await loginService.logout();
  }
}

class EmailPassModel {
  final String email;
  final String password;

  EmailPassModel({required this.email, required this.password});
}
