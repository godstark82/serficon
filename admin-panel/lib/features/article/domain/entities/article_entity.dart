
abstract class ArticleEntity {
  final String id;
  final String title;
  final String journalId;
  final String issueId;
  final String volumeId;
  final String documentType;
  final String status;
  final String pdf;
  final String abstractString;
  final List<String> keywords;
  final List<String> mainSubjects;
  final List<String> references;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  ArticleEntity({
    required this.id,
    required this.journalId,
    required this.issueId,
    required this.volumeId,
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
