import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/committee/data/models/committee_member_model.dart';
import 'package:conference_admin/features/committee/domain/repositories/committee_repo.dart';

class GetMemberByidUseCase
    extends UseCase<DataState<CommitteeMemberModel>, String> {
  final CommitteeRepo repo;

  GetMemberByidUseCase(this.repo);
  @override
  Future<DataState<CommitteeMemberModel>> call(String params) {
    return repo.getCommitteeMemberById(params);
  }
}
