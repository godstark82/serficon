part of 'pages_bloc.dart';

abstract class PagesState extends Equatable {
  const PagesState();

  @override
  List<Object> get props => [];
}

class PagesInitial extends PagesState {}

class PageLoading extends PagesState {}

class PagesLoaded extends PagesState {
  final Map<String, PagesModel> pages;

  const PagesLoaded(this.pages);
}

class PageError extends PagesState {
  final String message;

  const PageError(this.message);
}
