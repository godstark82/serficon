import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/committee/data/models/committee_member_model.dart';
import 'package:conference_admin/features/committee/domain/repositories/committee_repo.dart';

class UpdateMemberUseCase extends UseCase<void, CommitteeMemberModel> {
  final CommitteeRepo repo;
  UpdateMemberUseCase(this.repo);
  @override
  Future<void> call(CommitteeMemberModel params) async {
    await repo.updateCommitteeMember(params);
  }
}
