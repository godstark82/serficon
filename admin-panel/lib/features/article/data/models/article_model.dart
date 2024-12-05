import 'package:conference_admin/features/article/domain/entities/article_entity.dart';

class ArticleModel extends ArticleEntity {
  ArticleModel(
      {required super.id,
      required super.createdAt,
      required super.title,
      required super.email,
      required super.articleTitle,
      required super.documentType,
      required super.affiliation,
      required super.status,
      required super.abstract,
      required super.keywords,
      required super.paperType,
      required super.pdfUrl,
      required super.authors});

  // fromJson
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? 'N/A',
      createdAt: DateTime.tryParse((json['created_at']).toString()) ?? DateTime.now(),
      title: json['title'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      articleTitle: json['article_title'] ?? 'N/A',
      documentType: json['document_type'] ?? 'N/A',
      affiliation: json['affiliation'] ?? 'N/A',
      status: ArticleStatus.values.byName(json['status'] ?? 'N/A'),
      abstract: json['abstract'] ?? 'N/A',
      keywords: json['keywords'] != null 
          ? (json['keywords'] is String 
              ? [json['keywords']] 
              : List<String>.from(json['keywords']))
          : [],
      paperType: json['paper_type'] != null
          ? (json['paper_type'] is String
              ? [json['paper_type']]
              : List<String>.from(json['paper_type']))
          : [],
      pdfUrl: json['pdf_url'] ?? 'N/A',
      authors: json['authors'] != null ? List<AuthorModel>.from(json['authors'].map((author) => AuthorModel.fromJson(author))) : [],
    );
  }

  // copyWith
  ArticleModel copyWith({
    String? id,
    DateTime? createdAt,
    String? title,
    String? email,
    String? articleTitle,
    String? documentType,
    String? affiliation,
    ArticleStatus? status,
    String? abstract,
    List<String>? keywords,
    List<String>? paperType,
    String? pdfUrl,
    List<AuthorModel>? authors,
  }) {
    return ArticleModel(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        title: title ?? this.title,
        email: email ?? this.email,
        articleTitle: articleTitle ?? this.articleTitle,
        documentType: documentType ?? this.documentType,
        affiliation: affiliation ?? this.affiliation,
        status: status ?? this.status,
        abstract: abstract ?? this.abstract,
        keywords: keywords ?? this.keywords,
        paperType: paperType ?? this.paperType,
        pdfUrl: pdfUrl ?? this.pdfUrl,
        authors: authors ?? this.authors);
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'article_title': articleTitle,
      'document_type': documentType,
      'affiliation': affiliation,
      'status': status.value,
      'abstract': abstract,
      'keywords': keywords,
      'paper_type': paperType,
      'pdf_url': pdfUrl,
      'authors': authors,
    };
  }
}
