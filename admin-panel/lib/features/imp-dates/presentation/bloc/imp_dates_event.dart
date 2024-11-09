part of 'imp_dates_bloc.dart';

abstract class ImpDatesEvent extends Equatable {
  const ImpDatesEvent();

  @override
  List<Object> get props => [];
}

class GetDatesEvent extends ImpDatesEvent {}

class UpdateDatesEvent extends ImpDatesEvent {
  final List< DateModel> dates;

  const UpdateDatesEvent({required this.dates});
}
