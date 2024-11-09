import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/faq/data/models/faq_model.dart';
import 'package:conference_admin/features/faq/domain/repositories/faq_repo.dart';

class FaqRepoImpl extends FaqRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<DataState<void>> addReviewProcess(FaqModel faq) async {
    try {
      await firestore.collection('faq').doc('review_process').set(faq.toJson());
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<void>> addSubmissionGuidelines(FaqModel faq) async {
    try {
      await firestore
          .collection('faq')
          .doc('submission_guidelines')
          .set(faq.toJson());
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<FaqModel>> getReviewProcess() async {
    try {
      final doc = await firestore.collection('faq').doc('review_process').get();
      return DataSuccess(FaqModel.fromJson(doc.data() ?? {}));
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<FaqModel>> getSubmissionGuidelines() async {
    try {
      final doc =
          await firestore.collection('faq').doc('submission_guidelines').get();
      return DataSuccess(FaqModel.fromJson(doc.data() ?? {}));
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<void>> updateReviewProcess(FaqModel faq) async {
    try {
      await firestore.collection('faq').doc('review_process').set(faq.toJson());
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<void>> updateSubmissionGuidelines(FaqModel faq) async {
    try {
      await firestore
          .collection('faq')
          .doc('submission_guidelines')
          .set(faq.toJson());
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}
