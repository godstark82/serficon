part of 'pages_bloc.dart';

abstract class PagesEvent extends Equatable {
  const PagesEvent();

  @override
  List<Object> get props => [];
}

class GetPageByIdEvent extends PagesEvent {
  final String id;

  const GetPageByIdEvent(this.id);
}

class GetPagesEvent extends PagesEvent {}

class UpdatePageEvent extends PagesEvent {
  final PagesModel id;

  const UpdatePageEvent(this.id);
}
