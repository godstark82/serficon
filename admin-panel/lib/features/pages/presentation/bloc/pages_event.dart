part of 'pages_bloc.dart';

abstract class PagesEvent extends Equatable {
  const PagesEvent();

  @override
  List<Object> get props => [];
}

class GetPagesEvent extends PagesEvent {}

class UpdatePageEvent extends PagesEvent {
  final PagesModel id;

  const UpdatePageEvent(this.id);
}
