import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/pages/data/models/pages_model.dart';

abstract class PageRepo {
  Future<DataState<PagesModel>> getPage(String id);
  Future<DataState<void>> updatePage(PagesModel page);
}
