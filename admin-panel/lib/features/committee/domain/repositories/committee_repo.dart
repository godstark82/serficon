import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/committee/data/models/committee_member_model.dart';

abstract class CommitteeRepo {
  // Add Commitee Member
  Future<void> addCommitteeMember(CommitteeMemberModel member);

  // Delete Committee Member
  Future<void> deleteCommitteeMember(String id);

  // Edit Member Details
  Future<void> updateCommitteeMember(CommitteeMemberModel newMember);

  // Get All Members
  Future<DataState<List<CommitteeMemberModel>>> getAllCommitteeMembers();

  // Get Single Member
  Future<DataState<CommitteeMemberModel>> getCommitteeMemberById(String id);
}
