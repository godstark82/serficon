import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/usecase/usecase.dart';
import 'package:conference_admin/features/imp-dates/data/models/date_model.dart';
import 'package:conference_admin/features/imp-dates/domain/repositories/date_repo.dart';

class UpdateDatesUseCase extends UseCase<DataState<void>, List<DateModel>> {
  final DateRepo repo;

  UpdateDatesUseCase(this.repo);

  @override
  Future<DataState<void>> call(List<DateModel> params) async =>
      repo.addImportantDate(params);
}
