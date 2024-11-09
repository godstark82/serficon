part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  final String? role;
  const LoginState({this.role});

  @override
  List<Object> get props => [role!];
}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginDoneState extends LoginState {
  const LoginDoneState({required super.role});
}
