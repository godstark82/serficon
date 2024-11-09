part of 'users_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<AdminModel>? users;
  const UsersLoaded({
    required this.users,
  });
}

class UsersLoadedSpecific extends UsersState {
  final AdminModel? user;
  const UsersLoadedSpecific({
    required this.user,
  });
}
