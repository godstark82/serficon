part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}



class HomeComponentLoaded extends HomeState {
  final List<HomeComponentModel> componentModel;

  const HomeComponentLoaded(this.componentModel);
}


class HomeComponentError extends HomeState {
  final String message;

  const HomeComponentError(this.message);
}

class HomeComponentsLoading extends HomeState {}

class HomeComponentsUpdated extends HomeState {}

class HomeDisplayUpdated extends HomeState {}

class HomeComponentCreated extends HomeState {}

class HomeComponentDeleted extends HomeState {}
