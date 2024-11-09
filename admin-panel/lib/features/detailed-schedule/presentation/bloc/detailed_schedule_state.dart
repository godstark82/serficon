part of 'detailed_schedule_bloc.dart';

abstract class DetailedScheduleState extends Equatable {
  const DetailedScheduleState();

  @override
  List<Object> get props => [];
}

class DetailedScheduleInitial extends DetailedScheduleState {}

class DetailedScheduleLoading extends DetailedScheduleState {}

class DetailedScheduleLoaded extends DetailedScheduleState {
  final List<DetailedScheduleModel> detailedSchedules;

  const DetailedScheduleLoaded(this.detailedSchedules);
}

class DetailedScheduleError extends DetailedScheduleState {
  final String message;

  const DetailedScheduleError(this.message);
}

class SingleDetailedScheduleLoaded extends DetailedScheduleState {
  final DetailedScheduleModel detailedSchedule;

  const SingleDetailedScheduleLoaded(this.detailedSchedule);
}

class SingleDetailedScheduleError extends DetailedScheduleState {
  final String message;

  const SingleDetailedScheduleError(this.message);
}

class SingleDetailedScheduleLoading extends DetailedScheduleState {}
