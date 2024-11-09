part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetHomeEvent extends HomeEvent {}

class UpdateHeroEvent extends HomeEvent {
  final HomeHeroModel heroModel;

  const UpdateHeroEvent(this.heroModel);
}

class UpdateWelcomeEvent extends HomeEvent {
  final HomePresidentWelcomeModel welcomeModel;

  const UpdateWelcomeEvent(this.welcomeModel);
}

class UpdateScopeEvent extends HomeEvent {
  final HomeCongressScopeModel scopeModel;

  const UpdateScopeEvent(this.scopeModel);
}

class UpdateStreamEvent extends HomeEvent {
  final HomeCongressStreamModel streamModel;

  const UpdateStreamEvent(this.streamModel);
}

class UpdatePublicationEvent extends HomeEvent {
  final HomePublicationModel publicationModel;

  const UpdatePublicationEvent(this.publicationModel);
}

class UpdateWcuEvent extends HomeEvent {
  final HomeWhyChooseUsModel wcuModel;

  const UpdateWcuEvent(this.wcuModel);
}
