import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/login/domain/repositories/login_repo.dart';

class LogoutUsecase extends UseCase<void, void> {
  final LoginRepo loginRepo;

  LogoutUsecase(this.loginRepo);
  @override
  Future<void> call(void params) async {
    await loginRepo.logOut();
  }
}
