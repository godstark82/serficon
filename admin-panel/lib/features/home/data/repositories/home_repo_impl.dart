import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/home/data/models/home_model.dart';
import 'package:conference_admin/features/home/data/models/home_models_others.dart';
import 'package:conference_admin/features/home/domain/repositories/home_repo.dart';

class HomeRepoImpl extends HomeRepo {
  final FirebaseFirestore firestore;
  HomeRepoImpl({required this.firestore});
  @override
  Future<DataState<HomeModel>> getHomeData() async {
    final response = await firestore.collection('home').get();
    if (response.docs.isEmpty) {
      return DataFailed('No data found');
    }
    final heroData = response.docs.firstWhere((doc) => doc.id == 'hero');
    final publicationData =
        response.docs.firstWhere((doc) => doc.id == 'publication');
    final presidentWelcomeData =
        response.docs.firstWhere((doc) => doc.id == 'president-welcome');
    final congressScopeData =
        response.docs.firstWhere((doc) => doc.id == 'congress-scope');
    final congressStreamData =
        response.docs.firstWhere((doc) => doc.id == 'congress-stream');
    final whyChooseUsData =
        response.docs.firstWhere((doc) => doc.id == 'why-choose-us');

    return DataSuccess(HomeModel(
      hero: HomeHeroModel.fromJson(heroData.data()),
      presidentWelcome:
          HomePresidentWelcomeModel.fromJson(presidentWelcomeData.data()),
      congressScope: HomeCongressScopeModel.fromJson(congressScopeData.data()),
      congressStream:
          HomeCongressStreamModel.fromJson(congressStreamData.data()),
      publication: HomePublicationModel.fromJson(publicationData.data()),
      whyChooseUs: HomeWhyChooseUsModel.fromJson(whyChooseUsData.data()),
    ));
  }

  @override
  Future<DataState<void>> updateCongressScope(
      HomeCongressScopeModel congressScope) async {
    await firestore
        .collection('home')
        .doc('congress-scope')
        .update(congressScope.toJson());
    return DataSuccess(null);
  }

  @override
  Future<DataState<void>> updateCongressStream(
      HomeCongressStreamModel congressStream) async {
    await firestore
        .collection('home')
        .doc('congress-stream')
        .update(congressStream.toJson());
    return DataSuccess(null);
  }

  @override
  Future<DataState<void>> updateHero(HomeHeroModel hero) async {
    await firestore.collection('home').doc('hero').update(hero.toJson());
    return DataSuccess(null);
  }

  @override
  Future<DataState<void>> updatePresidentWelcome(
      HomePresidentWelcomeModel presidentWelcome) async {
    await firestore
        .collection('home')
        .doc('president-welcome')
        .update(presidentWelcome.toJson());
    return DataSuccess(null);
  }

  @override
  Future<DataState<void>> updateWhyChooseUs(
      HomeWhyChooseUsModel whyChooseUs) async {
    await firestore
        .collection('home')
        .doc('why-choose-us')
        .update(whyChooseUs.toJson());
    return DataSuccess(null);
  }

  @override
  Future<DataState<void>> updatePublication(
      HomePublicationModel publication) async {
    await firestore
        .collection('home')
        .doc('publication')
        .update(publication.toJson());
    return DataSuccess(null);
  }
}
