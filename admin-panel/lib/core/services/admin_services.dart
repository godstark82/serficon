import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class AdminServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;





  Future<void> deleteSocialLink(String id) async {
    try {
      await _firestore.collection('socialLinks').doc(id).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getSocialLinks() async {
    try {
      final snapshot = await _firestore.collection('socialLinks').get();
      final data = snapshot.docs.map((doc) => (doc.data())).toList();
      return data.isNotEmpty ? data : [];
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<void> updateSocialLink(String name, String url) async {
    try {
      final snapshot = await _firestore
          .collection('socialLinks')
          .where('name', isEqualTo: name)
          .get();
      if (snapshot.docs.isNotEmpty) {
        await _firestore
            .collection('socialLinks')
            .doc(snapshot.docs[0].id)
            .update({'url': url});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
