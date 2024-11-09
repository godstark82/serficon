import 'dart:developer';

import 'package:conference_admin/features/login/data/models/admin_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
class LoginConst {
  static AdminModel? currentUser;

  static void updateLoginConsts({
    AdminModel? user,
  }) async {
    currentUser = user ?? currentUser;
    await Hive.box('cache').put('currentUser', currentUser?.toJson());
  }

  static void clearLoginConsts() async {
    currentUser = null;
    await Hive.box('cache').clear();
  }

  static void printLoginConsts() {
    log('currentUserName: ${currentUser?.name}');
    log('currentUserId: ${currentUser?.id}');
    log('currentUserEmail: ${currentUser?.email}');
  }

  static Future<void> getCurrentUser() async {
    final hiveBox = Hive.box('cache');
    final userJson = await hiveBox.get('currentUser');
    currentUser = userJson != null
        ? AdminModel.fromJson((userJson as Map).cast<String, dynamic>())
        : null;
    printLoginConsts();
  }
}
