import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conference_admin/features/registrations/data/models/registration_model.dart';

class RegistrationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// get all registrations
  Future<List<RegistrationModel>> getRegistrations() async {
    try {
      final snapshot = await _firestore.collection('registrations').get();
      return snapshot.docs.map((doc) => RegistrationModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Error getting registrations: $e');
    }
  }
}
