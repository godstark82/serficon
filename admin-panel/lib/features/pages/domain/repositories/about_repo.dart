import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/pages/data/models/page_model.dart';

abstract class AboutRepo {
  //! New Components
  Future<DataState<List<PagesModel>>> getPages();
  Future<DataState<void>> updatePage(PagesModel page);
  Future<DataState<void>> deletePage(String id);
  Future<DataState<void>> createPage(PagesModel page);
  Future<DataState<PagesModel>> getPage(String id);
}
