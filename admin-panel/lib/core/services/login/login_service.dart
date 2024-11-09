import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:conference_admin/core/snack_bars.dart';

import 'package:conference_admin/features/login/data/models/admin_model.dart';
import 'package:conference_admin/routes.dart';

class LoginService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //! Change Password
  Future<void> changePassword(String email, String newPassword) async {
    try {
      // Get user document from Firestore
      final userDoc = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userDoc.docs.isEmpty) {
        throw Exception('User not found');
      }

      // Update password in Firebase Auth
      if (auth.currentUser == null) {
        Get.offAllNamed(Routes.login);
      }
      await auth.currentUser?.updatePassword(newPassword);

      // Update password in Firestore
      await userDoc.docs.first.reference.update({'password': newPassword});
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to change password: ${e.toString()}');
    }
  }

  //! Sign up with email and password
  Future<User?> signUp(AdminModel myuser, String role) async {
    try {
      //! Create new User in firebase
      final UserCredential credentials =
          await auth.createUserWithEmailAndPassword(
              email: myuser.email!, password: myuser.password!);

      //! Create new document in users collection for userdata
      final User? user = credentials.user;
     
      myuser.id = user?.uid;
      await firestore
          .collection('users')
          .doc(user?.uid)
          .set({'createdAt': DateTime.now(), ...myuser.toJson()});
      return credentials.user;

    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          MySnacks.showErrorSnack('The password provided is too weak.');
          log('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          MySnacks.showErrorSnack('Email Already Exists...');
          log('The account already exists for that email.');
        } else {
          MySnacks.showErrorSnack(e.code);
          log(e.code);
        }
      } else {
        log(e.toString());
      }
      return null;
    }
  }

  //! Sign in with email and password
  Future<AdminModel?> signIn(String email, String password) async {
    try {
      // Sign in the user with email and password
      final UserCredential credentials = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Get the current user
      final User? user = credentials.user;

      if (user != null) {
        // Fetch user data from Firestore
        final DocumentSnapshot<Map<String, dynamic>> userDoc =
            await firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          final userData = userDoc.data();
          if (userData != null && userData.containsKey('role')) {
            return AdminModel.fromJson(userData);
          } else {
            MySnacks.showErrorSnack('No role found for this user.');
            log('No role found for this user.');
            return null;
          }
        } else {
          MySnacks.showErrorSnack('User does not exist.');
          return null;
        }
      }
      return null;
      
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          MySnacks.showErrorSnack('No user found for that email.');
          log('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          MySnacks.showErrorSnack('Wrong password provided.');
          log('Wrong password provided.');
        } else {
          MySnacks.showErrorSnack(e.message ?? 'Authentication error.');
          log(e.code);
        }
      } else {
        MySnacks.showErrorSnack('An error occurred: ${e.toString()}');
        log(e.toString());
      }
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      log(e.toString());
    }
  }
}
