
import 'package:conference_admin/features/article/domain/entities/article_entity.dart';

class ArticleModel extends ArticleEntity {
  ArticleModel(
      {required super.id,
      required super.journalId,
      required super.abstractString,
      required super.issueId,
      required super.volumeId,
      required super.documentType,
      required super.image,
      required super.keywords,
      required super.mainSubjects,
      required super.createdAt,
      required super.updatedAt,
      required super.pdf,
      required super.references,
      required super.status,
      required super.title});

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] as String,
      journalId: json['journalId'] as String,
      abstractString: (json['abstractString']).toString(),
      issueId: json['issueId'] as String,
      volumeId: json['volumeId'] as String,
      documentType: json['documentType'] as String,
      image: json['image'] as String,
      keywords: List<String>.from(json['keywords']),
      mainSubjects: List<String>.from(json['mainSubjects']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      pdf: json['pdf'] as String,
      references: List<String>.from(json['references']),
      title: json['title'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'journalId': journalId,
      'abstractString': abstractString,
      'issueId': issueId,
      'volumeId': volumeId,
      'documentType': documentType,
      'image': image,
      'keywords': keywords,
      'mainSubjects': mainSubjects,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'pdf': pdf,
      'references': references,
      'title': title,
      'status': status,
    };
  }

  factory ArticleModel.fromEntity(ArticleEntity entity) {
    return ArticleModel(
      id: entity.id,
      journalId: entity.journalId,
      abstractString: entity.abstractString,
      issueId: entity.issueId,
      volumeId: entity.volumeId,
      documentType: entity.documentType,
      image: entity.image,
      keywords: entity.keywords,
      mainSubjects: entity.mainSubjects,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      pdf: entity.pdf,
      references: entity.references,
      title: entity.title,
      status: entity.status,
    );
  }

  //copy with
  ArticleModel copyWith({
    String? id,
    String? abstractString,
    String? issueId,
    String? volumeId,
    String? documentType,
    String? image,
    List<String>? keywords,
    List<String>? mainSubjects,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? pdf,
    List<String>? references,
    String? title,
    String? journalId,
    String? status,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      abstractString: abstractString ?? this.abstractString,
      journalId: journalId ?? this.journalId,
      issueId: issueId ?? this.issueId,
      volumeId: volumeId ?? this.volumeId,
      documentType: documentType ?? this.documentType,
      image: image ?? this.image,
      keywords: keywords ?? this.keywords,
      mainSubjects: mainSubjects ?? this.mainSubjects,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pdf: pdf ?? this.pdf,
      references: references ?? this.references,
      title: title ?? this.title,
      status: status ?? this.status,
    );
  }
}

enum ArticleStatus {
  pending('Pending'),
  accepted('Accepted'),
  rejected('Rejected');

  final String value;
  const ArticleStatus(this.value);
}
