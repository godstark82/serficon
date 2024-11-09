import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/detailed-schedule/data/models/detailed_schedule_model.dart';
import 'package:conference_admin/features/detailed-schedule/domain/repositories/schedule_repo.dart';

class UpdateScheduleUseCase
    extends UseCase<DataState<void>, DetailedScheduleModel> {
  final ScheduleRepo repository;

  UpdateScheduleUseCase(this.repository);

  @override
  Future<DataState<void>> call(DetailedScheduleModel params) async {
    await repository.updateDetailedSchedule(params);
    return DataSuccess(null);
  }
}
