
abstract class ArticleEntity {
  final String id;
  final String title;
  final String documentType;
  final String status;
  final String pdf;
  final String abstractString;
  final List<String> keywords;
  final List<String> mainSubjects;
  final List<String> references;
  final String image;
  final String author;
  final DateTime createdAt;
  final DateTime updatedAt;

  ArticleEntity({
    required this.id,
    required this.author,
    required this.documentType,
    required this.status,
    required this.abstractString,
    required this.image,
    required this.keywords,
    required this.mainSubjects,
    required this.createdAt,
    required this.updatedAt,
    required this.pdf,
    required this.references,
    required this.title,
  });
}
