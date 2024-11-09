import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/imp-dates/data/models/date_model.dart';
import 'package:conference_admin/features/imp-dates/domain/repositories/date_repo.dart';

class GetDatesUseCase extends UseCase<DataState<List<DateModel>>, void> {
  final DateRepo repo;

  GetDatesUseCase(  this.repo);

  @override
  Future<DataState<List<DateModel>>> call(void params) async =>
      repo.getImportantDates();
}
