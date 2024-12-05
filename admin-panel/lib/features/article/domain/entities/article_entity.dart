class AuthorModel {
  final String name;
  final String email;
  final String affiliation;

  AuthorModel({
    required this.name,
    required this.email,
    required this.affiliation,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      name: json['name'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      affiliation: json['affiliation'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'affiliation': affiliation,
    };
  }
}

enum ArticleStatus {
  pending('pending'),
  accepted('accepted'),
  rejected('rejected');

  final String value;
  const ArticleStatus(this.value);
}

abstract class ArticleEntity {
  final String id;
  final String title;
  final String email;
  final String articleTitle;
  final String documentType;
  final String affiliation;
  final ArticleStatus status;
  final String abstract;
  final List<String> keywords;
  final List<String> paperType;
  final String pdfUrl;
  final List<AuthorModel> authors;
  final DateTime createdAt;

  ArticleEntity({
    required this.id,
    required this.title,
    required this.email,
    required this.articleTitle,
    required this.documentType,
    required this.affiliation,
    required this.status,
    required this.abstract,
    required this.keywords,
    required this.paperType,
    required this.pdfUrl,
    required this.authors,
    required this.createdAt,
  });
}
