import 'package:conference_admin/features/home/data/models/home_models_others.dart';

class HomeModel {
  final HomeHeroModel hero;
  final HomePresidentWelcomeModel presidentWelcome;
  final HomeCongressScopeModel congressScope;
  final HomeCongressStreamModel congressStream;
  final HomeWhyChooseUsModel whyChooseUs;
  final HomePublicationModel publication;

  HomeModel({
    required this.hero,
    required this.presidentWelcome,
    required this.congressScope,
    required this.congressStream,
    required this.whyChooseUs,
    required this.publication,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        hero: HomeHeroModel.fromJson(json['hero']),
        presidentWelcome:
            HomePresidentWelcomeModel.fromJson(json['presidentWelcome']),
        congressScope: HomeCongressScopeModel.fromJson(json['congressScope']),
        congressStream:
            HomeCongressStreamModel.fromJson(json['congressStream']),
        whyChooseUs: HomeWhyChooseUsModel.fromJson(json['whyChooseUs']),
        publication: HomePublicationModel.fromJson(json['publication']),
      );

  Map<String, dynamic> toJson() => {
        'hero': hero.toJson(),
        'presidentWelcome': presidentWelcome.toJson(),
        'congressScope': congressScope.toJson(),
        'congressStream': congressStream.toJson(),
        'whyChooseUs': whyChooseUs.toJson(),
        'publication': publication.toJson(),
      };

  // copy with
  HomeModel copyWith({
    HomeHeroModel? hero,
    HomePresidentWelcomeModel? presidentWelcome,
    HomeCongressScopeModel? congressScope,
    HomeCongressStreamModel? congressStream,
    HomeWhyChooseUsModel? whyChooseUs,
    HomePublicationModel? publication,
  }) =>
      HomeModel(
        hero: hero ?? this.hero,
        presidentWelcome: presidentWelcome ?? this.presidentWelcome,
        congressScope: congressScope ?? this.congressScope,
        congressStream: congressStream ?? this.congressStream,
        whyChooseUs: whyChooseUs ?? this.whyChooseUs,
        publication: publication ?? this.publication,
      );
}
