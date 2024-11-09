part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}




class LoginInitiateLoginEvent extends LoginEvent {
  final EmailPassModel emailPass;

  const LoginInitiateLoginEvent(this.emailPass);
}

class ChangePasswordEvent extends LoginEvent {
  final String email;
  final String newPassword;

  const ChangePasswordEvent({required this.email, required this.newPassword});
}

class LogoutEvent extends LoginEvent {}
