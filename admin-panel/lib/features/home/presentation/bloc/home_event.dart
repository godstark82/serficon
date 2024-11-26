part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}



//! Home Component
class UpdateComponentEvent extends HomeEvent {
  final HomeComponentModel componentModel;

  const UpdateComponentEvent(this.componentModel);
}

class CreateComponentEvent extends HomeEvent {
  final HomeComponentModel componentModel;

  const CreateComponentEvent(this.componentModel);
}

class DeleteComponentEvent extends HomeEvent {
  final String id;

  const DeleteComponentEvent(this.id);
}
//! Home Display
class UpdateDisplayEvent extends HomeEvent {
  final String id;
  final bool display;

  const UpdateDisplayEvent(this.id, this.display);
}

class GetHomeComponentEvent extends HomeEvent {}
