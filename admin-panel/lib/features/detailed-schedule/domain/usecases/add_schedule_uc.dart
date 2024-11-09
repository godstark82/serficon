import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/detailed-schedule/data/models/detailed_schedule_model.dart';
import 'package:conference_admin/features/detailed-schedule/domain/repositories/schedule_repo.dart';

class AddScheduleUseCase extends UseCase<void, DetailedScheduleModel> {
  final ScheduleRepo repository;

  AddScheduleUseCase(this.repository);
  @override
  Future<void> call(DetailedScheduleModel params) async {
    return repository.addDetailedSchedule(params);
  }
}
