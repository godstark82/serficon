import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:conference_admin/features/login/data/models/admin_model.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:conference_admin/core/const/login_const.dart';
import 'package:conference_admin/features/login/data/repositories/login_repo_impl.dart';

import 'package:conference_admin/features/login/domain/usecases/login_usecase.dart';
import 'package:conference_admin/features/login/domain/usecases/logout_usecase.dart';
import 'package:conference_admin/routes.dart';
import 'package:conference_admin/core/services/login/login_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  final LoginService loginService;
  LoginBloc(
      this.loginUsecase,
      this.logoutUsecase,
      this.loginService)
      : super(LoginInitial()) {
    //
    on<LoginInitiateLoginEvent>(onLogin);
    on<LogoutEvent>(onLogout);
  }


  void onLogout(LogoutEvent event, Emitter<LoginState> emit) async {
    try {
      await logoutUsecase.call({}).whenComplete(() {
        Get.offAllNamed(Routes.login);
        LoginConst.clearLoginConsts();
      });

      emit(LoginInitial());
    } catch (e) {
      log(e.toString());
    }
  }

  void onLogin(LoginInitiateLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    // try {
    final user = await loginUsecase.call(event.emailPass).onError((e, st) {
      log(e.toString());
      emit(LoginInitial());
      return null;
    });
    if (user != null) {
      emit(const LoginDoneState(role: 'admin'));
      LoginConst.updateLoginConsts(
          user: AdminModel(
        id: user.id,
        name: user.name,
        email: user.email,
      ));
      LoginConst.printLoginConsts();
      Get.offAllNamed(Routes.dashboard);
    } else {
      emit(LoginInitial());
    }
  }
}
