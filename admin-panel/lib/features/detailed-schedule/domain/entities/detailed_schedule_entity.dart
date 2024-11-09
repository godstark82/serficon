import 'package:conference_admin/features/detailed-schedule/data/models/detailed_schedule_model.dart';
import 'package:equatable/equatable.dart';

class DayDetailEntity extends Equatable {
  final DateTime startTime;
  final DateTime endTime;
  final String description;

  const DayDetailEntity({
    required this.startTime,
    required this.endTime,
    required this.description,
  });

  // toModel
  DayDetailModel toModel() => DayDetailModel(
        startTime: startTime,
        endTime: endTime,
        description: description,
      );

  // toListModel



  @override
  List<Object?> get props => [startTime, endTime, description];
}

class DetailedScheduleEntity extends Equatable {
  final String id;
  final DateTime date;
  final List<DayDetailEntity> dayDetails;

  const DetailedScheduleEntity({
    required this.id,
    required this.date,
    required this.dayDetails,
  });

  // toModel
  DetailedScheduleModel toModel() => DetailedScheduleModel(
        id: id,
        date: date,
        dayDetails: dayDetails.map((e) => e.toModel()).toList(),
      );

    List<DayDetailModel> dayDetailsListEntityToModel(List<DayDetailEntity> dayDetails) =>
      dayDetails.map((e) => e.toModel()).toList();
    
  
  @override
  List<Object?> get props => [id, date, dayDetails];
}
