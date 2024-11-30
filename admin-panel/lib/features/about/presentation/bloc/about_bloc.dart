import 'package:bloc/bloc.dart';
import 'package:conference_admin/core/const/no_params.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/about/domain/usecases/create_component_uc.dart';
import 'package:conference_admin/features/about/domain/usecases/delete_component_uc.dart';
import 'package:conference_admin/features/about/domain/usecases/get_page_by_id_uc.dart';
import 'package:conference_admin/features/about/domain/usecases/get_pages_uc.dart';
import 'package:conference_admin/features/about/domain/usecases/update_component_uc.dart';
import 'package:conference_admin/features/pages/data/models/pages_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'about_event.dart';
part 'about_state.dart';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  final UpdateAboutPageUsecase updatePageUseCase;
  final CreateAboutPageUsecase createPageUseCase;
  final DeleteAboutPageUsecase deletePageUseCase;
  final GetAboutPagesUsecase getPagesUseCase;
  final GetAboutPageByIdUsecase getPageByIdUseCase;

  AboutBloc(
    this.updatePageUseCase,
    this.createPageUseCase,
    this.deletePageUseCase,
    this.getPagesUseCase,
    this.getPageByIdUseCase,
  ) : super(AboutInitial()) {
    //
    on<UpdatePageEvent>(_onUpdatePage);
    on<CreatePageEvent>(_onCreatePage);
    on<DeletePageEvent>(_onDeletePage);
    on<GetPagesEvent>(_onGetPages);
    on<GetPageEvent>(_onGetPageById);
  }

  //! Home
  void _onUpdatePage(UpdatePageEvent event, Emitter<AboutState> emit) async {
    final result = await updatePageUseCase(event.page);
    if (result is DataFailed) {
      debugPrint(result.message);
    }
    add(GetPagesEvent());
  }

  void _onCreatePage(CreatePageEvent event, Emitter<AboutState> emit) async {
    final result = await createPageUseCase(event.page);
    if (result is DataFailed) {
      debugPrint(result.message);
    }
    add(GetPagesEvent());
  }

  void _onDeletePage(DeletePageEvent event, Emitter<AboutState> emit) async {
    final result = await deletePageUseCase(event.id);
    if (result is DataFailed) {
      debugPrint(result.message);
    }
    add(GetPagesEvent());
  }

  void _onGetPages(GetPagesEvent event, Emitter<AboutState> emit) async {
    emit(AboutPagesLoading());
    final result = await getPagesUseCase(NoParams());
    if (result is DataFailed && result.message != null) {
      debugPrint(result.message);
      emit(AboutPagesError(result.message ?? ''));
    }
    if (result is DataSuccess && result.data != null) {
      emit(AboutPagesLoaded(result.data!));
    }
  }

  void _onGetPageById(GetPageEvent event, Emitter<AboutState> emit) async {
    emit(AboutPagesLoading());
    final result = await getPageByIdUseCase(event.id);
    if (result is DataFailed && result.message != null) {
      debugPrint(result.message);
      emit(AboutPagesError(result.message ?? ''));
    }
    if (result is DataSuccess && result.data != null) {
      emit(AboutSinglePageLoaded(result.data!));
    }
  }
}
