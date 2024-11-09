import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/detailed-schedule/data/models/detailed_schedule_model.dart';
import 'package:conference_admin/features/detailed-schedule/domain/repositories/schedule_repo.dart';

class ScheduleRepoImpl extends ScheduleRepo {
  @override
  Future<DataState<List<DetailedScheduleModel>>> getDetailedSchedule() async {
    // fetch from firestore
    try {
      final detailedSchedule = await FirebaseFirestore.instance
          .collection('detailed-schedule')
          .get();
      final data = (detailedSchedule.docs
          .map((doc) => DetailedScheduleModel.fromJson(doc.data()))
          .toList());
      return DataSuccess(data);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<DetailedScheduleModel>> getSingleDetailedSchedule(
      String id) async {
    try {
      final detailedSchedule = await FirebaseFirestore.instance
          .collection('detailed-schedule')
          .doc(id)
          .get();
      return DataSuccess(
          DetailedScheduleModel.fromJson(detailedSchedule.data()));
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<void> addDetailedSchedule(
      DetailedScheduleModel detailedSchedule) async {
    // try {
      final docRef =
          FirebaseFirestore.instance.collection('detailed-schedule').doc();
      detailedSchedule = detailedSchedule.copyWith(id: docRef.id);
      await docRef.set(detailedSchedule.toJson());
    // } catch (e) {
      // print(e);
    // }
  }

  @override
  Future<void> deleteDetailedSchedule(String id) async {
    await FirebaseFirestore.instance
        .collection('detailed-schedule')
        .doc(id)
        .delete();
  }

  @override
  Future<void> updateDetailedSchedule(
      DetailedScheduleModel detailedSchedule) async {
    await FirebaseFirestore.instance
        .collection('detailed-schedule')
        .doc(detailedSchedule.id)
        .update(detailedSchedule.toJson());
  }
}
