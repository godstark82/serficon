import 'package:conference_admin/core/models/card_model.dart';
import 'package:conference_admin/core/models/stream_card_model.dart';
import 'package:conference_admin/features/home/domain/entities/home_component_entity.dart';
import 'package:conference_admin/features/home/presentation/widgets/component_widget.dart';
import 'package:flutter/material.dart';

class HomeComponentModel extends HomeComponentEntity {
  const HomeComponentModel({
    super.description,
    super.bgColor = Colors.transparent,
    required super.order,
    super.cards,
    super.streamCards,
    required super.type,
    required super.id,
    required super.title,
    required super.htmlContent,
    required super.display,
  });

  factory HomeComponentModel.fromJson(Map<String, dynamic> json) =>
      HomeComponentModel(
        description: json['description'],
        bgColor: json['bgColor'] != null
            ? Color.fromRGBO(
                _parseColorComponent(json['bgColor']['r']),
                _parseColorComponent(json['bgColor']['g']),
                _parseColorComponent(json['bgColor']['b']),
                1.0,
              )
            : Colors.transparent,
        order: json['order'] ?? 0,
        type: HomeComponentType.fromJson(json['type']),
        cards: json['cards'] != null
            ? List<CardModel>.from(
                json['cards'].map((x) => CardModel.fromJson(x)))
            : [],
        streamCards: json['streamCards'] != null
            ? List<StreamCardModel>.from(
                json['streamCards'].map((x) => StreamCardModel.fromJson(x)))
            : [],
        id: json['id'],
        title: json['title'],
        htmlContent: json['htmlContent'],
        display: json['display'],
      );

  // Helper method to safely parse color component values
  static int _parseColorComponent(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'bgColor': {
        'r': bgColor.red,
        'g': bgColor.green,
        'b': bgColor.blue,
        'a': bgColor.alpha,
      },
      'order': order,
      'type': type.value,
      'id': id,
      'title': title,
      'htmlContent': htmlContent,
      'display': display,
      'cards': cards != null ? cards!.map((x) => x.toJson()).toList() : [],
      'streamCards': streamCards != null
          ? streamCards!.map((x) => x.toJson()).toList()
          : [],
    };
  }

  Widget toWidget(BuildContext context) => HomeComponentWidget(component: this);

  @override
  List<Object?> get props =>
      [id, title, htmlContent, display, type, description, bgColor];

  @override
  String toString() =>
      'HomeComponentModel(id: $id, title: $title, htmlContent: $htmlContent, display: $display, type: $type, description: $description, bgColor: $bgColor)';

  // copyWith
  HomeComponentModel copyWith({
    String? title,
    String? htmlContent,
    bool? display,
    String? id,
    HomeComponentType? type,
    List<CardModel>? cards,
    List<StreamCardModel>? streamCards,
    String? description,
    Color? bgColor,
    int? order,
  }) =>
      HomeComponentModel(
        order: order ?? this.order,
        description: description ?? this.description,
        bgColor: bgColor ?? this.bgColor,
        cards: cards ?? this.cards,
        streamCards: streamCards ?? this.streamCards,
        id: id ?? this.id,
        title: title ?? this.title,
        htmlContent: htmlContent ?? this.htmlContent,
        display: display ?? this.display,
        type: type ?? this.type,
      );
}
