part of 'committee_bloc.dart';

abstract class CommitteeState extends Equatable {
  const CommitteeState();

  @override
  List<Object> get props => [];
}

class CommitteeInitial extends CommitteeState {}

class LoadingSingleCommitteeState extends CommitteeState {}

class LoadingAllCommitteeState extends CommitteeState {}

class LoadedSingleCommitteeState extends CommitteeState {
  final CommitteeMemberModel member;
  const LoadedSingleCommitteeState(this.member);
}

class LoadedAllCommitteeState extends CommitteeState {
  final List<CommitteeMemberModel> members;
  const LoadedAllCommitteeState(this.members);
}

class ErrorSingleCommitteeMember extends CommitteeState {
  final String msg;
  const ErrorSingleCommitteeMember(this.msg);
}

class ErrorAllCommitteeMember extends CommitteeState {
  final String msg;
  const ErrorAllCommitteeMember(this.msg);
}
