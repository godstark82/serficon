import 'package:conference_admin/features/login/domain/entities/admin_enitiy.dart';

class AdminModel extends AdminEnitiy {
  AdminModel({
    super.email,
    super.password,
    super.name,
    super.id,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      email: json['email'],
      password: json['password'],
      name: json['name'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'id': id,
    };
  }

 
}
