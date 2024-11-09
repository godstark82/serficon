import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/committee/data/models/committee_member_model.dart';
import 'package:conference_admin/features/committee/domain/repositories/committee_repo.dart';

class AddMemberUsecase extends UseCase<void, CommitteeMemberModel> {
  final CommitteeRepo repo;

  AddMemberUsecase(this.repo);
  @override
  Future<void> call(CommitteeMemberModel params) async {
    await repo.addCommitteeMember(params);
  }
}
