import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/detailed-schedule/domain/repositories/schedule_repo.dart';

class DeleteScheduleUseCase extends UseCase<void, String> {
  final ScheduleRepo repository;

  DeleteScheduleUseCase(this.repository);

  @override
  Future<void> call(String params) async {
    return repository.deleteDetailedSchedule(params);
  }
}
