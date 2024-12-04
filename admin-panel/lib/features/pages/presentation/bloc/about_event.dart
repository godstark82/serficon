part of 'about_bloc.dart';

abstract class AboutEvent extends Equatable {
  const AboutEvent();

  @override
  List<Object> get props => [];
}

class GetPagesEvent extends AboutEvent {}

class CreatePageEvent extends AboutEvent {
  final PagesModel page;

  const CreatePageEvent(this.page);
}

class UpdatePageEvent extends AboutEvent {
  final PagesModel page;

  const UpdatePageEvent(this.page);
}

class DeletePageEvent extends AboutEvent {
  final String id;

  const DeletePageEvent(this.id);
}

class GetPageEvent extends AboutEvent {
  final String id;

  const GetPageEvent(this.id);
}
