import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/committee/domain/repositories/committee_repo.dart';

class DeleteMemberUsecase extends UseCase<void, String> {
  final CommitteeRepo repo;
  DeleteMemberUsecase(this.repo);
  @override
  Future<void> call(String params) async {
    await repo.deleteCommitteeMember(params);
  }
}
