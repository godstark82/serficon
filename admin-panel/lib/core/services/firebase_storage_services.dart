import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker_web/image_picker_web.dart';

class FirebaseStorageServices {
  static final FirebaseStorage storage = FirebaseStorage.instance;

  static Future<String> pickAndUploadSvg() async {
    try {
      final Uint8List? svgBytes = await ImagePickerWeb.getImageAsBytes();

      if (svgBytes == null) {
        throw Exception('No SVG file selected');
      }

      final String fileName = 'logo_${DateTime.now().millisecondsSinceEpoch}.svg';

      final Reference storageRef = storage
          .refFromURL('gs://conference-340f2.appspot.com')
          .child(fileName);

      final metadata = SettableMetadata(
        contentType: 'image/svg+xml',
      );

      final TaskSnapshot taskSnapshot = 
          await storageRef.putData(svgBytes, metadata);

      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }


  static Future<String> pickAndUploadImage() async {
    try {
      final Uint8List? image = await ImagePickerWeb.getImageAsBytes();

      if (image == null) {
        throw Exception('No image selected');
      }

      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      final String downloadUrl = await uploadImage(image, fileName);

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> uploadImage(
      Uint8List imageBytes, String fileName) async {
    try {
      final Reference storageRef = storage
          .refFromURL('gs://conference-340f2.appspot.com')
          .child(fileName);

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
      );

      final TaskSnapshot taskSnapshot =
          await storageRef.putData(imageBytes, metadata);

      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }
}
