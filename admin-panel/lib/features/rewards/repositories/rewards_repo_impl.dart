import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/models/card_model.dart';
import 'package:conference_admin/features/rewards/repositories/rewards_repo.dart';

class RewardsRepoImpl extends RewardsRepo {
  final firestore = FirebaseFirestore.instance;
  @override
  Future<DataState<List<CardModel>>> getRewards() async {
    try {
      final snapshot = await firestore.collection('rewards').get();
      final rewards =
          snapshot.docs.map((doc) => CardModel.fromJson(doc.data())).toList();
      return DataSuccess(rewards);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<void>> addRewards(CardModel rewards) async {
    try {
      final docRef = firestore.collection('rewards').doc();
      rewards = rewards.copyWith(id: docRef.id);
      await docRef.set(rewards.toJson());
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }

  @override
  Future<DataState<void>> deleteRewards(String id) async {
    try {
      await firestore.collection('rewards').doc(id).delete();
      return DataSuccess(null);
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}
