import 'package:equatable/equatable.dart';

class PagesEntity extends Equatable {
  final String id;
  final String title;
  final String htmlContent;
  final String? parent;

  const PagesEntity(
      {required this.id,
      required this.title,
      required this.htmlContent,
      this.parent});
  @override
  List<Object?> get props => [id, title, htmlContent, parent];
}
