import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/detailed-schedule/data/models/detailed_schedule_model.dart';

abstract class ScheduleRepo {
  Future<DataState<List<DetailedScheduleModel>>> getDetailedSchedule();
  Future<DataState<DetailedScheduleModel>> getSingleDetailedSchedule(String id);
  Future<void> updateDetailedSchedule(DetailedScheduleModel detailedSchedule);
  Future<void> deleteDetailedSchedule(String id);
  Future<void> addDetailedSchedule(DetailedScheduleModel detailedSchedule);
}
