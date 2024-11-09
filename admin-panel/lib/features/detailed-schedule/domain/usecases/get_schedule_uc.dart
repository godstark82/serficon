import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/detailed-schedule/data/models/detailed_schedule_model.dart';
import 'package:conference_admin/features/detailed-schedule/domain/repositories/schedule_repo.dart';

class GetAllScheduleUseCase
    extends UseCase<DataState<List<DetailedScheduleModel>>, void> {
  final ScheduleRepo repository;

  GetAllScheduleUseCase(this.repository);

  @override
  Future<DataState<List<DetailedScheduleModel>>> call(void params) async {
    return await repository.getDetailedSchedule();
  }
}
