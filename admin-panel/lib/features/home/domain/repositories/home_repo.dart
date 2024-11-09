import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/home/data/models/home_model.dart';
import 'package:conference_admin/features/home/data/models/home_models_others.dart';

abstract class HomeRepo {
  Future<DataState<HomeModel>> getHomeData();
  Future<DataState<void>> updateHero(HomeHeroModel hero);
  Future<DataState<void>> updatePresidentWelcome(
      HomePresidentWelcomeModel presidentWelcome);
  Future<DataState<void>> updateCongressScope(
      HomeCongressScopeModel congressScope);
  Future<DataState<void>> updatePublication(HomePublicationModel publication);
  Future<DataState<void>> updateCongressStream(
      HomeCongressStreamModel congressStream);
  Future<DataState<void>> updateWhyChooseUs(HomeWhyChooseUsModel whyChooseUs);
}
