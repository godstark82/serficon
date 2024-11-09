import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/login/data/models/admin_model.dart';
import 'package:flutter/foundation.dart';

class UsersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DataState<List<AdminModel>>> getAllUsers() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('users').get();
      return DataSuccess(querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AdminModel.fromJson(data);
      }).toList());
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching users: $e');
      }
      return DataFailed(e.toString());
    }
  }

  Future<DataState<AdminModel?>> getUserInfo(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          return DataSuccess(AdminModel.fromJson(userData));
        } else {
          if (kDebugMode) {
            print('No role found for this user.');
          }
          return DataFailed('User not found');
        }
      } else {
        if (kDebugMode) {
          print('User does not exist.');
        }
        return DataFailed('User not found');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user info: $e');
      }
      return DataFailed(e.toString());
    }
  }

  Future<void> updateUserJournals(
      String userId, List<String> journalIds) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'journalIds': journalIds,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user journals: $e');
      }
    }
  }
}
