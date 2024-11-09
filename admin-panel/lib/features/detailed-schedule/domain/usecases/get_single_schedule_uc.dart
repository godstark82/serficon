import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/detailed-schedule/data/models/detailed_schedule_model.dart';
import 'package:conference_admin/features/detailed-schedule/domain/repositories/schedule_repo.dart';

class GetSingleScheduleUseCase
    extends UseCase<DataState<DetailedScheduleModel>, String> {
  final ScheduleRepo repository;

  GetSingleScheduleUseCase(this.repository);

  @override
  Future<DataState<DetailedScheduleModel>> call(String params) async {
    return await repository.getSingleDetailedSchedule(params);
  }
}
