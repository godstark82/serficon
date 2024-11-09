part of 'imp_dates_bloc.dart';

abstract class ImpDatesState extends Equatable {
  const ImpDatesState();

  @override
  List<Object> get props => [];
}

class ImpDatesInitial extends ImpDatesState {}

class ImpDatesLoading extends ImpDatesState {}

class ImpDatesLoaded extends ImpDatesState {
  final List<DateModel> dates;

  const ImpDatesLoaded({required this.dates});

  @override
  List<Object> get props => [dates];
}

class ImpDatesError extends ImpDatesState {
  final String message;

  const ImpDatesError({required this.message});

  @override
  List<Object> get props => [message];
}

class ImpDatesUpdated extends ImpDatesState {}
