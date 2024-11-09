
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/committee/data/models/committee_member_model.dart';
import 'package:conference_admin/features/committee/domain/repositories/committee_repo.dart';
import 'package:get/get.dart';

class CommitteeRepoImpl implements CommitteeRepo {
  final firestore = FirebaseFirestore.instance;
  @override
  Future<void> addCommitteeMember(CommitteeMemberModel member) async {
    try {
      final docRef = firestore.collection('committee').doc();
      member = member.copyWith(id: docRef.id);
      await docRef.set(member.toJson());
    } catch (e) {
      Get.printError(info: e.toString());
    }
  }

  @override
  Future<void> deleteCommitteeMember(String id) async {
    try {
      await firestore.collection('committee').doc(id).delete();
    } catch (e) {
      Get.printError(info: e.toString());
    }
  }

  @override
  Future<DataState<List<CommitteeMemberModel>>> getAllCommitteeMembers() async {
    try {
      final snapshot = await firestore.collection('committee').get();
      final members = snapshot.docs.map((doc) {
        return CommitteeMemberModel.fromJson(doc.data()..['id'] = doc.id);
      }).toList();
      return DataSuccess(members);
    } catch (e) {
      Get.printError(info: e.toString());
      return DataFailed('Failed to fetch committee members');
    }
  }

  @override
  Future<DataState<CommitteeMemberModel>> getCommitteeMemberById(
      String id) async {
    try {
      final doc = await firestore.collection('committee').doc(id).get();
      if (doc.exists) {
        final member =
            CommitteeMemberModel.fromJson(doc.data()!..['id'] = doc.id);
        return DataSuccess(member);
      } else {
        return DataFailed('Committee member not found');
      }
    } catch (e) {
      Get.printError(info: e.toString());
      return DataFailed('Failed to fetch committee member');
    }
  }

  @override
  Future<void> updateCommitteeMember(CommitteeMemberModel newMember) async {
    try {
      final docRef = firestore.collection('committee').doc(newMember.id);
      await docRef.update(newMember.toJson());
    } catch (e) {
      Get.printError(info: e.toString());
    }
  }
}
