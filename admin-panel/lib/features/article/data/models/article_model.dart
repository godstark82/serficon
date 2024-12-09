enum ArticleStatus {
  pending("pending"),
  published("published"),
  rejected("rejected");

  final String value;
  const ArticleStatus(this.value);
}

class ArticleModel {
  final String id;
  final String title;
  final String name;
  final String email;
  final String articleTitle;
  final String documentType;
  final String affiliation;
  final String abstractText; // Renamed to avoid conflict with reserved keyword.
  final String keywords;
  final String topicType;
  final List<String> paperType;
  final ArticleStatus status;
  final DateTime createdAt;
  final String pdfUrl;
  final List<AdditionalAuthor> additionalAuthors;

  ArticleModel({
    required this.id,
    required this.title,
    required this.name,
    required this.email,
    required this.articleTitle,
    required this.documentType,
    required this.affiliation,
    required this.abstractText,
    required this.keywords,
    required this.topicType,
    required this.paperType,
    required this.status,
    required this.createdAt,
    required this.pdfUrl,
    required this.additionalAuthors,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? 'N/A',
      title: json['title'] ?? 'N/A',
      name: json['name'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      articleTitle: json['article_title'] ?? 'N/A',
      documentType: json['document_type'] ?? 'N/A',
      affiliation: json['affiliation'] ?? 'N/A',
      abstractText: json['abstract'] ?? 'N/A',
      keywords: json['keywords'] ?? 'N/A',
      topicType: json['topic_type'] ?? 'N/A',
      paperType: List<String>.from(json['paper_type'] ?? []),
      status: json['status'] != null
          ? ArticleStatus.values.byName(json['status'])
          : ArticleStatus.pending,
      createdAt: json['created_at'] != null
          ? DateTime.parse((json['created_at']).toString())
          : DateTime.now(),
      pdfUrl: json['pdf_url'] ?? 'N/A',
      additionalAuthors: (json['additional_authors'] as List)
          .map((e) => AdditionalAuthor.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'name': name,
      'email': email,
      'article_title': articleTitle,
      'document_type': documentType,
      'affiliation': affiliation,
      'abstract': abstractText,
      'keywords': keywords,
      'topic_type': topicType,
      'paper_type': paperType,
      'status': status.value,
      'created_at': createdAt.toIso8601String(),
      'pdf_url': pdfUrl,
      'additional_authors': additionalAuthors.map((e) => e.toJson()).toList(),
    };
  }

  // copyWith method
  ArticleModel copyWith({
    String? title,
    String? name,
    String? email,
    String? articleTitle,
    String? documentType,
    String? affiliation,
    String? abstractText,
    String? keywords,
    String? topicType,
    List<String>? paperType,
    ArticleStatus? status,
    DateTime? createdAt,
    String? pdfUrl,
    List<AdditionalAuthor>? additionalAuthors,
    String? id,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      name: name ?? this.name,
      email: email ?? this.email,
      articleTitle: articleTitle ?? this.articleTitle,
      documentType: documentType ?? this.documentType,
      affiliation: affiliation ?? this.affiliation,
      abstractText: abstractText ?? this.abstractText,
      keywords: keywords ?? this.keywords,
      topicType: topicType ?? this.topicType,
      paperType: paperType ?? this.paperType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      additionalAuthors: additionalAuthors ?? this.additionalAuthors,
    );
  }
}

class AdditionalAuthor {
  final String name;
  final String affiliation;
  final String email;
  final bool isCorresponding;

  AdditionalAuthor({
    required this.name,
    required this.affiliation,
    required this.email,
    required this.isCorresponding,
  });

  factory AdditionalAuthor.fromJson(Map<String, dynamic> json) {
    return AdditionalAuthor(
      name: json['name'],
      affiliation: json['affiliation'],
      email: json['email'],
      isCorresponding: json['is_corresponding'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'affiliation': affiliation,
      'email': email,
      'is_corresponding': isCorresponding,
    };
  }
}
