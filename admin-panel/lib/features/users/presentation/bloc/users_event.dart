part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class GetUsersEvent extends UsersEvent {}

class GetSpecificUserEvent extends UsersEvent {
  final String userId;
  const GetSpecificUserEvent({
    required this.userId,
  });
}

class UpdateUserJournalsEvent extends UsersEvent {
  final String userId;
  final List<String> journalIds;
  const UpdateUserJournalsEvent({
    required this.userId,
    required this.journalIds,
  });
}
