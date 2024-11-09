import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/imp-dates/data/models/date_model.dart';
import 'package:conference_admin/features/imp-dates/domain/repositories/date_repo.dart';

class DateRepoImpl implements DateRepo {
  final FirebaseFirestore firestore;
  DateRepoImpl({required this.firestore});
  @override
  Future<DataState<void>> addImportantDate(List<DateModel> dates) async {
    try {
      await firestore
          .collection('dates')
          .doc('important-dates')
          .set({'dates': dates.map((e) => e.toJson()).toList()});
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<List<DateModel>>> getImportantDates() async {
    try {
      final snapshot =
          await firestore.collection('dates').doc('important-dates').get();
      final dates = ((snapshot.data() ?? {})['dates'] ?? []) as List<dynamic>;
      return DataSuccess(dates.map((e) => DateModel.fromJson(e)).toList());
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}
