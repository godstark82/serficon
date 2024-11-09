
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/core/models/card_model.dart';

abstract class RewardsRepo {
  Future<DataState<List<CardModel>>> getRewards();
  Future<DataState<void>> addRewards(CardModel rewards);
  Future<DataState<void>> deleteRewards(String id);
}

