part of 'detailed_schedule_bloc.dart';

abstract class DetailedScheduleEvent extends Equatable {
  const DetailedScheduleEvent();

  @override
  List<Object> get props => [];
}

class GetDetailedScheduleEvent extends DetailedScheduleEvent {}

class GetSingleDetailedScheduleEvent extends DetailedScheduleEvent {
  final String id;

  const GetSingleDetailedScheduleEvent(this.id);
}

class UpdateDetailedScheduleEvent extends DetailedScheduleEvent {
  final DetailedScheduleModel detailedSchedule;

  const UpdateDetailedScheduleEvent(this.detailedSchedule);
}

class AddDetailedScheduleEvent extends DetailedScheduleEvent {
  final DetailedScheduleModel detailedSchedule;

  const AddDetailedScheduleEvent(this.detailedSchedule);
}

class DeleteDetailedScheduleEvent extends DetailedScheduleEvent {
  final String id;

  const DeleteDetailedScheduleEvent(this.id);
}
