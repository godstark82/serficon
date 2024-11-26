import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/home/data/models/home_component_model.dart';

abstract class HomeRepo {
  //! New Components
  Future<DataState<List<HomeComponentModel>>> getHomeComponents();
  Future<DataState<void>> updateHomeComponent(HomeComponentModel component);
  Future<DataState<void>> deleteHomeComponent(String id);
  Future<DataState<void>> createHomeComponent(HomeComponentModel component);
  Future<DataState<void>> updateDisplay(String id, bool display);
}
