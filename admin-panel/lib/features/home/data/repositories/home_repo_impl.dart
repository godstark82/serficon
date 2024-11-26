import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/home/data/models/home_component_model.dart';
import 'package:conference_admin/features/home/domain/repositories/home_repo.dart';

class HomeRepoImpl extends HomeRepo {
  final FirebaseFirestore firestore;
  HomeRepoImpl({required this.firestore});
  //! New Components
  @override
  Future<DataState<void>> createHomeComponent(
      HomeComponentModel component) async {
    try {
      final docRef = firestore.collection('home').doc();
      component = component.copyWith(id: docRef.id);
      await docRef.set(component.toJson());
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<void>> deleteHomeComponent(String id) async {
    try {
      await firestore.collection('home').doc(id).delete();
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<void>> updateDisplay(String id, bool display) async {
    try {
      await firestore.collection('home').doc(id).update({'display': display});
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<void>> updateHomeComponent(
      HomeComponentModel component) async {
    try {
      await firestore
          .collection('home')
          .doc(component.id)
          .update(component.toJson());
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<List<HomeComponentModel>>> getHomeComponents() async {
    try {
      final response = await firestore.collection('home').get();
      return DataSuccess(response.docs
          .map((doc) => HomeComponentModel.fromJson(doc.data()))
          .toList());
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}
