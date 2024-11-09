import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/committee/data/models/committee_member_model.dart';
import 'package:conference_admin/features/committee/domain/repositories/committee_repo.dart';

class GetAllMemberUseCase
    extends UseCase<DataState<List<CommitteeMemberModel>>, void> {
  final CommitteeRepo repo;

  GetAllMemberUseCase(this.repo);

  @override
  Future<DataState<List<CommitteeMemberModel>>> call(void params) async {
    return await repo.getAllCommitteeMembers();
  }
}
