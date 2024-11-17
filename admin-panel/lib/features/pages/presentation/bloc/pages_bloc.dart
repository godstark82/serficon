import 'package:bloc/bloc.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/pages/data/models/pages_model.dart';
import 'package:conference_admin/features/pages/domain/usecases/get_page_uc.dart';
import 'package:conference_admin/features/pages/domain/usecases/update_page_uc.dart';
import 'package:equatable/equatable.dart';

part 'pages_event.dart';
part 'pages_state.dart';

class PagesBloc extends Bloc<PagesEvent, PagesState> {
  final GetPageUseCase getPageUseCase;
  final UpdatePageUseCase updatePageUseCase;
  PagesBloc(this.getPageUseCase, this.updatePageUseCase)
      : super(PagesInitial()) {
    on<GetPagesEvent>(_getPages);
    on<UpdatePageEvent>(_onUpdatePage);
    on<GetPageByIdEvent>(_onGetPageById);
  }

  void _onGetPageById(GetPageByIdEvent event, Emitter<PagesState> emit) async {
    emit(PageByIdLoading());
    final status = await getPageUseCase.call(event.id);
    if (status is DataSuccess && status.data != null) {
      emit(PageByIdLoaded(status.data!));
    } else {
      emit(const PageByIdError('Failed to load page'));
    }
  }

  void _onUpdatePage(UpdatePageEvent event, Emitter<PagesState> emit) async {
    final status = await updatePageUseCase.call(event.id);
    if (status is DataFailed) {
      print('Failed to update page');
    }
    // add(GetPagesEvent());
  }

  void _getPages(GetPagesEvent event, Emitter<PagesState> emit) async {
    emit(PageLoading());
    // organising committee
    final oc = await getPageUseCase.call('organising-committee');
    // scientific committee member
    final scm = await getPageUseCase.call('scientific-committee-member');
    // scientific lead
    final sl = await getPageUseCase.call('scientific-lead');

    if (oc is DataSuccess &&
        scm is DataSuccess &&
        sl is DataSuccess &&
        oc.data != null &&
        scm.data != null &&
        sl.data != null) {
      emit(PagesLoaded({
        'oc': oc.data!,
        'scm': scm.data!,
        'sl': sl.data!,
      }));
    } else {
      emit(const PageError('Failed to load pages'));
    }
  }
}
