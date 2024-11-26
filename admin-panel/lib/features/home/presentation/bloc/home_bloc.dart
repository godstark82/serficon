import 'package:bloc/bloc.dart';
import 'package:conference_admin/core/const/no_params.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/home/data/models/home_component_model.dart';
import 'package:conference_admin/features/home/domain/usecases/create_component_uc.dart';
import 'package:conference_admin/features/home/domain/usecases/delete_component_uc.dart';
import 'package:conference_admin/features/home/domain/usecases/get_home.dart';
import 'package:conference_admin/features/home/domain/usecases/update_component_uc.dart';
import 'package:conference_admin/features/home/domain/usecases/update_display_uc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UpdateComponentUsecase updateComponentUseCase;
  final CreateComponentUsecase createComponentUseCase;
  final DeleteComponentUsecase deleteComponentUseCase;
  final UpdateDisplayUsecase updateDisplayUseCase;
  final GetHomeComponentsUsecase getHomeComponentUseCase;

  HomeBloc(
    this.updateComponentUseCase,
    this.createComponentUseCase,
    this.deleteComponentUseCase,
    this.updateDisplayUseCase,
    this.getHomeComponentUseCase,
  ) : super(HomeInitial()) {
    //
    on<UpdateComponentEvent>(_onUpdateComponent);
    on<CreateComponentEvent>(_onCreateComponent);
    on<DeleteComponentEvent>(_onDeleteComponent);
    on<UpdateDisplayEvent>(_onUpdateDisplay);
    on<GetHomeComponentEvent>(_onGetHomeComponent);
  }

  //! Home
  Future<void> _onUpdateComponent(
      UpdateComponentEvent event, Emitter<HomeState> emit) async {
    final result = await updateComponentUseCase.call(event.componentModel);
    if (result is DataFailed && result.message != null) {
      debugPrint(result.message!);
      return;
    }
    add(GetHomeComponentEvent());
  }

  Future<void> _onCreateComponent(
      CreateComponentEvent event, Emitter<HomeState> emit) async {
    final result = await createComponentUseCase.call(event.componentModel);
    if (result is DataFailed && result.message != null) {
      debugPrint(result.message!);
      return;
    }
    add(GetHomeComponentEvent());
  }

  Future<void> _onDeleteComponent(
      DeleteComponentEvent event, Emitter<HomeState> emit) async {
    final result = await deleteComponentUseCase.call(event.id);
    if (result is DataFailed && result.message != null) {
      debugPrint(result.message!);
      return;
    }
    add(GetHomeComponentEvent());
  }

  Future<void> _onUpdateDisplay(
      UpdateDisplayEvent event, Emitter<HomeState> emit) async {
    final result = await updateDisplayUseCase
        .call({'id': event.id, 'display': event.display});
    if (result is DataFailed && result.message != null) {
      debugPrint(result.message!);
      return;
    }
    add(GetHomeComponentEvent());
  }

  Future<void> _onGetHomeComponent(
      GetHomeComponentEvent event, Emitter<HomeState> emit) async {
    emit(HomeComponentsLoading());
    final result = await getHomeComponentUseCase.call(NoParams());
    if (result is DataSuccess && result.data != null) {
      emit(HomeComponentLoaded(result.data!));
    } else if (result is DataFailed && result.message != null) {
      emit(HomeComponentError(result.message!));
    }
  }
}
