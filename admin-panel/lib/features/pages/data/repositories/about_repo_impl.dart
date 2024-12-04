import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/pages/data/models/page_model.dart';
import 'package:conference_admin/features/pages/domain/repositories/about_repo.dart';


class AboutRepoImpl extends AboutRepo {
  final FirebaseFirestore firestore;
  AboutRepoImpl({required this.firestore});

  @override
  Future<DataState<List<PagesModel>>> getPages() async {
    try {
      final snapshot = await firestore.collection('pages').get();
      return DataSuccess(
          snapshot.docs.map((doc) => PagesModel.fromJson(doc.data())).toList());
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<void>> updatePage(PagesModel page) async {
    try {
      await firestore.collection('pages').doc(page.id).update(page.toJson());
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<void>> deletePage(String id) async {
    try {
      await firestore.collection('pages').doc(id).delete();
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<void>> createPage(PagesModel page) async {
    try {
      final docRef = firestore.collection('pages').doc();
      page = page.copyWith(id: docRef.id);
      await docRef.set(page.toJson());
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<PagesModel>> getPage(String id) async {
    try {
      final snapshot = await firestore.collection('pages').doc(id).get();
      return DataSuccess(PagesModel.fromJson(snapshot.data() ?? {}));
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}
