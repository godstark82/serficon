import 'package:bloc/bloc.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/home/data/models/home_model.dart';
import 'package:conference_admin/features/home/data/models/home_models_others.dart';
import 'package:conference_admin/features/home/domain/usecases/get_home_uc.dart';
import 'package:conference_admin/features/home/domain/usecases/update_hero_uc.dart';
import 'package:conference_admin/features/home/domain/usecases/update_publication_uc.dart';
import 'package:conference_admin/features/home/domain/usecases/update_scope_uc.dart';
import 'package:conference_admin/features/home/domain/usecases/update_stream_uc.dart';
import 'package:conference_admin/features/home/domain/usecases/update_wcu_uc.dart';
import 'package:conference_admin/features/home/domain/usecases/update_welcome_uc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeUseCase getHomeUseCase;
  final UpdateHeroUseCase updateHeroUseCase;
  final UpdateWelcomeUseCase updateWelcomeUseCase;
  final UpdateScopeUseCase updateScopeUseCase;
  final UpdateStreamUseCase updateStreamUseCase;
  final UpdatePublicationUseCase updatePublicationUseCase;
  final UpdateWcuUseCase updateWcuUseCase;

  HomeBloc(
      this.getHomeUseCase,
      this.updateHeroUseCase,
      this.updateWelcomeUseCase,
      this.updateScopeUseCase,
      this.updateStreamUseCase,
      this.updatePublicationUseCase,
      this.updateWcuUseCase)
      : super(HomeInitial()) {
    //
    on<GetHomeEvent>(_onGetHome);
    on<UpdateHeroEvent>(_onUpdateHero);
    on<UpdateWelcomeEvent>(_onUpdateWelcome);
    on<UpdateScopeEvent>(_onUpdateScope);
    on<UpdateStreamEvent>(_onUpdateStream);
    on<UpdatePublicationEvent>(_onUpdatePublication);
    on<UpdateWcuEvent>(_onUpdateWcu);
  }

  Future<void> _onGetHome(GetHomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    final result = await getHomeUseCase.call(null);
    if (result is DataSuccess && result.data != null) {
      emit(HomeLoaded(result.data!));
    } else if (result is DataFailed && result.message != null) {
      emit(HomeError(result.message!));
    }
  }

  Future<void> _onUpdateHero(
      UpdateHeroEvent event, Emitter<HomeState> emit) async {
    final result = await updateHeroUseCase.call(event.heroModel);
    //
    if (result is DataFailed && result.message != null) {
      debugPrint(result.message!);
    }
    add(GetHomeEvent());
  }

  Future<void> _onUpdateWelcome(
      UpdateWelcomeEvent event, Emitter<HomeState> emit) async {
    //
    final result = await updateWelcomeUseCase.call(event.welcomeModel);
    if (result is DataFailed && result.message != null) {
      debugPrint(result.message!);
    }
    add(GetHomeEvent());
  }

  Future<void> _onUpdateScope(
      UpdateScopeEvent event, Emitter<HomeState> emit) async {
    final result = await updateScopeUseCase.call(event.scopeModel);
    if (result is DataFailed && result.message != null) {
      debugPrint(result.message!);
    }
    add(GetHomeEvent());
  }

  Future<void> _onUpdateStream(
      UpdateStreamEvent event, Emitter<HomeState> emit) async {
    final result = await updateStreamUseCase.call(event.streamModel);
    if (result is DataFailed && result.message != null) {
      debugPrint(result.message!);
    }
    add(GetHomeEvent());
  }

  Future<void> _onUpdatePublication(
      UpdatePublicationEvent event, Emitter<HomeState> emit) async {
    final result = await updatePublicationUseCase.call(event.publicationModel);
    if (result is DataFailed && result.message != null) {
      debugPrint(result.message!);
    }
    add(GetHomeEvent());
  }

  Future<void> _onUpdateWcu(
      UpdateWcuEvent event, Emitter<HomeState> emit) async {
    final result = await updateWcuUseCase.call(event.wcuModel);
    if (result is DataFailed && result.message != null) {
      debugPrint(result.message!);
    }
    add(GetHomeEvent());
  }
}
