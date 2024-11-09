import 'package:equatable/equatable.dart';

class DateEntity extends Equatable {
  final DateTime? date;
  final String? description;

  const DateEntity({required this.date, required this.description});

  @override
  List<Object?> get props => [date, description];
}
