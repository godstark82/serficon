part of 'about_bloc.dart';

abstract class AboutState extends Equatable {
  const AboutState();

  @override
  List<Object> get props => [];
}

class AboutInitial extends AboutState {}

class AboutPagesLoaded extends AboutState {
  final List<PagesModel> pages;

  const AboutPagesLoaded(this.pages);
}

class AboutPagesError extends AboutState {
  final String message;

  const AboutPagesError(this.message);
}

class AboutPagesLoading extends AboutState {}

class AboutSinglePageLoaded extends AboutState {
  final PagesModel page;

  const AboutSinglePageLoaded(this.page);
}

class SinglePageError extends AboutState {
  final String message;

  const SinglePageError(this.message);
}

class SinglePageLoading extends AboutState {}