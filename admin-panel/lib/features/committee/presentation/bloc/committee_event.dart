part of 'committee_bloc.dart';

abstract class CommitteeEvent extends Equatable {
  const CommitteeEvent();

  @override
  List<Object> get props => [];
}

class GetAllCommitteeMembersEvent extends CommitteeEvent {}

class GetCMemberByIdEvent extends CommitteeEvent {
  final String id;

  const GetCMemberByIdEvent(this.id);
}

class AddCommitteeMemberEvent extends CommitteeEvent {
  final CommitteeMemberModel member;

  const AddCommitteeMemberEvent(this.member);
}

class UpdateCommitteeMemberEvent extends CommitteeEvent {
  final CommitteeMemberModel member;
  const UpdateCommitteeMemberEvent(this.member);
}

class DeleteCommitteeMemberEvent extends CommitteeEvent {
  final String id;
  const DeleteCommitteeMemberEvent(this.id);
}
