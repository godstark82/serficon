import 'package:conference_admin/features/detailed-schedule/domain/entities/detailed_schedule_entity.dart';

class DetailedScheduleModel extends DetailedScheduleEntity {
  DetailedScheduleModel({
    required super.id,
    required super.date,
    required List<DayDetailModel> dayDetails,
  }) : super(dayDetails: dayDetails.map((e) => e.toEntity()).toList());

  // toEntity
  DetailedScheduleEntity toEntity() => DetailedScheduleEntity(
        id: id,
        date: date,
        dayDetails: dayDetails.toList(),
      );

  // fromJson
  factory DetailedScheduleModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) throw ArgumentError('json cannot be null');

    return DetailedScheduleModel(
      id: json['id'],
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      dayDetails: (json['dayDetails'] as List?)
              ?.map((e) => DayDetailModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  // toJson
  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'dayDetails': dayDetailsListEntityToModel(dayDetails)
            .map((e) => e.toJson())
            .toList(),
      };

  // copyWith
  DetailedScheduleModel copyWith({
    String? id,
    DateTime? date,
    List<DayDetailModel>? dayDetails,
  }) =>
      DetailedScheduleModel(
        id: id ?? this.id,
        date: date ?? this.date,
        dayDetails: dayDetails ?? dayDetailsListEntityToModel(this.dayDetails),
      );
}

class DayDetailModel extends DayDetailEntity {
  const DayDetailModel({
    required super.startTime,
    required super.endTime,
    required super.description,
  });

  // toEntity
  DayDetailEntity toEntity() => DayDetailEntity(
        startTime: startTime,
        endTime: endTime,
        description: description,
      );

  // fromJson
  factory DayDetailModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) throw ArgumentError('json cannot be null');

    return DayDetailModel(
      startTime: DateTime.tryParse(json['startTime']?.toString() ?? '') ??
          DateTime.now(),
      endTime: DateTime.tryParse(json['endTime']?.toString() ?? '') ??
          DateTime.now(),
      description: json['description']?.toString() ?? '',
    );
  }

  // toJson
  Map<String, dynamic> toJson() => {
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'description': description,
      };

  // copyWith
  DayDetailModel copyWith({
    DateTime? startTime,
    DateTime? endTime,
    String? description,
  }) =>
      DayDetailModel(
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        description: description ?? this.description,
      );
}
