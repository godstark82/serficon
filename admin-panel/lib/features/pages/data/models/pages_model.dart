import 'package:conference_admin/features/pages/domain/entities/pages_entity.dart';

class PagesModel extends PagesEntity {
  const PagesModel(
      {required super.id, required super.title, required super.htmlContent});

  factory PagesModel.fromJson(Map<String, dynamic> json) {
    return PagesModel(
      id: json['id'] ?? 'No ID',
      title: json['title'] ?? 'No Title',
      htmlContent: json['htmlContent'] ?? 'No Content',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'htmlContent': htmlContent,
    };
  }
}
