import 'package:conference_admin/features/pages/domain/entities/pages_entity.dart';

class PagesModel extends PagesEntity {
  const PagesModel(
      {required super.id,
      required super.title,
      required super.htmlContent,
      super.parent});

  factory PagesModel.fromJson(Map<String, dynamic> json) {
    return PagesModel(
      id: json['id'] ?? 'No ID',
      title: json['title'] ?? 'No Title',
      htmlContent: json['htmlContent'] ?? 'No Content',
      parent: json['parent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'htmlContent': htmlContent,
      'parent': parent,
    };
  }

  PagesModel copyWith({String? id, String? title, String? htmlContent, String? parent}) {
    return PagesModel(
      id: id ?? this.id,
      title: title ?? this.title,
      htmlContent: htmlContent ?? this.htmlContent,
      parent: parent ?? this.parent,
    );
  }
}
