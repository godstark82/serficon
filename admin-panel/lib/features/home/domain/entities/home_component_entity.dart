import 'package:conference_admin/core/models/card_model.dart';
import 'package:conference_admin/core/models/stream_card_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum HomeComponentType {
  withCards('with_cards'),
  withStream('with_stream');

  final String value;
  const HomeComponentType(this.value);

  static HomeComponentType fromJson(String json) {
    return HomeComponentType.values.firstWhere(
      (type) => type.value == json,
      orElse: () => HomeComponentType.withCards,
    );
  }
}

class HomeComponentEntity extends Equatable {
  final String id;
  final String title;
  final String htmlContent;
  final bool display;
  final String? description;
  final Color bgColor;
  final HomeComponentType type;
  final int order;
  final List<CardModel>? cards;
  final List<StreamCardModel>? streamCards;

  const HomeComponentEntity({
    required this.order,
    required this.type,
    required this.description,
    required this.bgColor,
    this.cards,
    this.streamCards,
    required this.id,
    required this.title,
    required this.htmlContent,
    required this.display,
  });

  @override
  List<Object?> get props =>
      [id, title, htmlContent, display, type, cards, streamCards, order, description, bgColor];
}
