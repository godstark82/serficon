part of 'article_bloc.dart';

abstract class ArticleState extends Equatable {
  const ArticleState();

  @override
  List<Object> get props => [];
}

class ArticleInitial extends ArticleState {}

class AllArticleLoadingState extends ArticleState {}

class AllArticleLoadedState extends ArticleState {
  final List<ArticleModel> articles;

  const AllArticleLoadedState({required this.articles});
}

class ArticleByVolumeIdLoadingState extends ArticleState {}

class ArticleByVolumeIdLoadedState extends ArticleState {
  final List<ArticleModel> articles;

  const ArticleByVolumeIdLoadedState({required this.articles});
}

class ArticleByJournalIdLoadingState extends ArticleState {}

class ArticleByJournalIdLoadedState extends ArticleState {
  final List<ArticleModel> articles;

  const ArticleByJournalIdLoadedState({required this.articles});
}

class ArticleByIssueIdLoadingState extends ArticleState {}

class ArticleByIssueIdLoadedState extends ArticleState {
  final List<ArticleModel> articles;

  const ArticleByIssueIdLoadedState({required this.articles});
}

class ArticleByIdLoadingState extends ArticleState {}

class ArticleByIdLoadedState extends ArticleState {
  final ArticleModel article;

  const ArticleByIdLoadedState({required this.article});
}

class ArticleErrorState extends ArticleState {
  final String message;

  const ArticleErrorState({required this.message});
}
