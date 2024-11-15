part of 'article_bloc.dart';

abstract class ArticleEvent extends Equatable {
  const ArticleEvent();

  @override
  List<Object> get props => [];
}

class GetAllArticleEvent extends ArticleEvent {}

class GetArticleByVolumeIdEvent extends ArticleEvent {
  final String volumeId;

  const GetArticleByVolumeIdEvent({required this.volumeId});
}

class GetArticleByJournalIdEvent extends ArticleEvent {
  final String journalId;

  const GetArticleByJournalIdEvent({required this.journalId});
}

class GetArticleByIssueIdEvent extends ArticleEvent {
  final String issueId;

  const GetArticleByIssueIdEvent({required this.issueId});
}

class GetArticleByIdEvent extends ArticleEvent {
  final String id;

  const GetArticleByIdEvent({required this.id});
}

class AddArticleEvent extends ArticleEvent {
  final ArticleModel article;

  const AddArticleEvent({required this.article});
}

class EditArticleEvent extends ArticleEvent {
  final ArticleModel article;

  const EditArticleEvent({required this.article});
}

class DeleteArticleEvent extends ArticleEvent {
  final String id;

  const DeleteArticleEvent({required this.id});
}
