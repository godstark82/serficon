import 'package:bloc/bloc.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/imp-dates/data/models/date_model.dart';
import 'package:conference_admin/features/imp-dates/domain/usecases/get_dates_uc.dart';
import 'package:conference_admin/features/imp-dates/domain/usecases/update_dates_uc.dart';
import 'package:equatable/equatable.dart';

part 'imp_dates_event.dart';
part 'imp_dates_state.dart';

class ImpDatesBloc extends Bloc<ImpDatesEvent, ImpDatesState> {
  final GetDatesUseCase getDatesUseCase;
  final UpdateDatesUseCase updateDatesUseCase;

  ImpDatesBloc(
    this.getDatesUseCase,
    this.updateDatesUseCase,
  ) : super(ImpDatesInitial()) {
    on<GetDatesEvent>(_onGetDates);
    on<UpdateDatesEvent>(_onUpdateDates);
  }

  Future<void> _onGetDates(
      GetDatesEvent event, Emitter<ImpDatesState> emit) async {
    emit(ImpDatesLoading());
    final result = await getDatesUseCase(null);
    if (result is DataSuccess && result.data != null) {
      emit(ImpDatesLoaded(dates: result.data!));
    } else if (result is DataFailed && result.message != null) {
      emit(ImpDatesError(message: result.message!));
    }
  }

  Future<void> _onUpdateDates(
      UpdateDatesEvent event, Emitter<ImpDatesState> emit) async {
    emit(ImpDatesLoading());
    final result = await updateDatesUseCase(event.dates);
    if (result is DataSuccess) {
      emit(ImpDatesUpdated());
    } else if (result is DataFailed && result.message != null) {
      emit(ImpDatesError(message: result.message!));
    }
  }
}
