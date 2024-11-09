import 'package:conference_admin/features/imp-dates/domain/entities/date_entity.dart';

class DateModel extends DateEntity {
  const DateModel({required super.date, required super.description});

  factory DateModel.fromJson(Map<String, dynamic> json) {
    return DateModel(
      date: DateTime.tryParse(json['date']) ?? DateTime.now(),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'description': description ?? '',
    };
  }


  @override
  List<Object?> get props => [date, description];

  DateModel copyWith({
    DateTime? date,
    String? description,
  }) {
    return DateModel(
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }
}
