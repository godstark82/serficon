import 'package:conference_admin/core/models/card_model.dart';

class HomeHeroModel {
  final String? image;
  final String htmlContent;

  HomeHeroModel({required this.image, required this.htmlContent});

  factory HomeHeroModel.fromJson(Map<String, dynamic> json) => HomeHeroModel(
        image: json['image'] ?? 'No Image',
        htmlContent: json['html_content'] ?? 'No Content',
      );

  Map<String, dynamic> toJson() => {
        'image': image,
        'html_content': htmlContent,
      };
}

class HomePresidentWelcomeModel {
  final String title;
  final String? image;
  final String htmlContent;

  HomePresidentWelcomeModel(
      {required this.title, required this.image, required this.htmlContent});

  factory HomePresidentWelcomeModel.fromJson(Map<String, dynamic> json) =>
      HomePresidentWelcomeModel(
        title: json['title'] ?? 'No Title',
        // sample image url
        image: json['image'] ?? 'No Image',
        htmlContent: json['html_content'] ?? 'No Content',
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'image': image,
        'html_content': htmlContent,
      };
}

class HomePublicationModel {
  final String? image;
  final String htmlContent;

  HomePublicationModel({required this.image, required this.htmlContent});

  factory HomePublicationModel.fromJson(Map<String, dynamic> json) =>
      HomePublicationModel(
        image: json['image'] ?? 'No Image',
        htmlContent: json['html_content'] ?? 'No Content',
      );

  Map<String, dynamic> toJson() => {
        'image': image,
        'html_content': htmlContent,
      };
}

class HomeCongressScopeModel {
  final String description;
  final String title;
  final List<CardModel> cards;

  HomeCongressScopeModel(
      {required this.description, required this.title, required this.cards});

  factory HomeCongressScopeModel.fromJson(Map<String, dynamic> json) =>
      HomeCongressScopeModel(
        description: json['description'] ?? 'No Description',
        title: json['title'] ?? 'No Title',
        cards: json['cards'] != null
            ? List<CardModel>.from(
                (json['cards'] as List).map((x) => CardModel.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        'description': description,
        'title': title,
        'cards': cards.map((x) => x.toJson()).toList(),
      };
}

class HomeWhyChooseUsModel {
  final String title;
  final String description;
  final List<CardModel> cards;

  HomeWhyChooseUsModel(
      {required this.title, required this.description, required this.cards});

  factory HomeWhyChooseUsModel.fromJson(Map<String, dynamic> json) =>
      HomeWhyChooseUsModel(
        title: json['title'] ?? 'No Title',
        description: json['description'] ?? 'No Description',
        cards: json['cards'] != null
            ? List<CardModel>.from(
                (json['cards'] as List).map((x) => CardModel.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'cards': cards.map((x) => x.toJson()).toList(),
      };
}

class HomeCongressStreamModel {
  final String title;
  final String description;
  final List<StreamCardModel> cards;

  HomeCongressStreamModel(
      {required this.title, required this.description, required this.cards});

  factory HomeCongressStreamModel.fromJson(Map<String, dynamic> json) =>
      HomeCongressStreamModel(
        title: json['title'] ?? 'No Title',
        description: json['description'] ?? 'No Description',
        cards: json['cards'] != null
            ? List<StreamCardModel>.from(
                (json['cards'] as List).map((x) => StreamCardModel.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'cards': cards.map((x) => x.toJson()).toList(),
      };
}

class StreamCardModel {
  final String title;
  final List<String> descriptions;

  StreamCardModel({required this.title, required this.descriptions});

  factory StreamCardModel.fromJson(Map<String, dynamic> json) =>
      StreamCardModel(
        title: json['title'] ?? 'No Title',
        descriptions: List<String>.from(json['descriptions'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'descriptions': descriptions.map((x) => x.toString()).toList(),
      };

  StreamCardModel copyWith({
    String? title,
    List<String>? descriptions, 
    
  }) =>
      StreamCardModel(
          title: title ?? this.title,
          descriptions: descriptions ?? this.descriptions);
}
