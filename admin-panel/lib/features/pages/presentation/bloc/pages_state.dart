part of 'pages_bloc.dart';

abstract class PagesState extends Equatable {
  const PagesState();

  @override
  List<Object> get props => [];
}

class PagesInitial extends PagesState {}

class PageLoading extends PagesState {}

class PageByIdLoading extends PagesState {}

class PageByIdLoaded extends PagesState {
  final PagesModel page;

  const PageByIdLoaded(this.page);
}

class PageByIdError extends PagesState {
  final String message;

  const PageByIdError(this.message);
}

class PagesLoaded extends PagesState {
  final Map<String, PagesModel> pages;

  const PagesLoaded(this.pages);
}

class PageError extends PagesState {
  final String message;

  const PageError(this.message);
}
