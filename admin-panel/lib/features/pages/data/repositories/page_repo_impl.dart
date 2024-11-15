import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/dependency_injection.dart';
import 'package:conference_admin/features/pages/data/models/pages_model.dart';
import 'package:conference_admin/features/pages/domain/repositories/page_repo.dart';

class PageRepoImpl implements PageRepo {
  final firestore = sl<FirebaseFirestore>();
  @override
  Future<DataState<PagesModel>> getPage(String id) async {
    try {
      final page = await firestore.collection('pages').doc(id).get();
      if (page.exists) {
        return DataSuccess(PagesModel.fromJson(page.data() ?? {}));
      } else {
        return DataFailed('Page not found');
      }
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<void>> updatePage(PagesModel page) async {
    // try {
      await firestore.collection('pages').doc(page.id).update(page.toJson());
      return DataSuccess(null);
    // } catch (e) {
      // return DataFailed(e.toString());
    // }
  }
}
