import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/imp-dates/data/models/date_model.dart';

abstract class DateRepo {
  Future<DataState<List<DateModel>>> getImportantDates();
  Future<DataState<void>> addImportantDate(List<DateModel> dates);
}
