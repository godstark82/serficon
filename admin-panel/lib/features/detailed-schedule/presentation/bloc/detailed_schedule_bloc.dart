import 'package:bloc/bloc.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/detailed-schedule/data/models/detailed_schedule_model.dart';
import 'package:conference_admin/features/detailed-schedule/domain/usecases/add_schedule_uc.dart';
import 'package:conference_admin/features/detailed-schedule/domain/usecases/delete_schedule_uc.dart';
import 'package:conference_admin/features/detailed-schedule/domain/usecases/get_schedule_uc.dart';
import 'package:conference_admin/features/detailed-schedule/domain/usecases/get_single_schedule_uc.dart';
import 'package:conference_admin/features/detailed-schedule/domain/usecases/update_schedule_uc.dart';
import 'package:equatable/equatable.dart';

part 'detailed_schedule_event.dart';
part 'detailed_schedule_state.dart';

class DetailedScheduleBloc
    extends Bloc<DetailedScheduleEvent, DetailedScheduleState> {
  final GetSingleScheduleUseCase getSingleScheduleUseCase;
  final UpdateScheduleUseCase updateScheduleUseCase;
  final DeleteScheduleUseCase deleteScheduleUseCase;
  final AddScheduleUseCase addScheduleUseCase;
  final GetAllScheduleUseCase getAllScheduleUseCase;

  DetailedScheduleBloc(
      this.getSingleScheduleUseCase,
      this.updateScheduleUseCase,
      this.deleteScheduleUseCase,
      this.addScheduleUseCase,
      this.getAllScheduleUseCase)
      : super(DetailedScheduleInitial()) {
    on<GetSingleDetailedScheduleEvent>(_onGetSingleDetailedSchedule);
    on<UpdateDetailedScheduleEvent>(_onUpdateDetailedSchedule);
    on<DeleteDetailedScheduleEvent>(_onDeleteDetailedSchedule);
    on<GetDetailedScheduleEvent>(_onGetDetailedSchedule);
    on<AddDetailedScheduleEvent>(_onAddDetailedSchedule);
  }

  Future<void> _onAddDetailedSchedule(AddDetailedScheduleEvent event,
      Emitter<DetailedScheduleState> emit) async {
    emit(SingleDetailedScheduleLoading());
    await addScheduleUseCase(event.detailedSchedule);
    add(GetDetailedScheduleEvent());
  }

  Future<void> _onGetSingleDetailedSchedule(
      GetSingleDetailedScheduleEvent event,
      Emitter<DetailedScheduleState> emit) async {
    emit(SingleDetailedScheduleLoading());
    final result = await getSingleScheduleUseCase(event.id);
    if (result is DataSuccess && result.data != null) {
      emit(SingleDetailedScheduleLoaded(result.data!));
    } else {
      emit(SingleDetailedScheduleError(result.message ?? 'Unknown error'));
    }
  }

  Future<void> _onUpdateDetailedSchedule(UpdateDetailedScheduleEvent event,
      Emitter<DetailedScheduleState> emit) async {
    emit(SingleDetailedScheduleLoading());
    await updateScheduleUseCase(event.detailedSchedule);
    add(GetDetailedScheduleEvent());
  }

  Future<void> _onDeleteDetailedSchedule(DeleteDetailedScheduleEvent event,
      Emitter<DetailedScheduleState> emit) async {
    emit(SingleDetailedScheduleLoading());
    await deleteScheduleUseCase(event.id);
    add(GetDetailedScheduleEvent());
  }

  Future<void> _onGetDetailedSchedule(GetDetailedScheduleEvent event,
      Emitter<DetailedScheduleState> emit) async {
    emit(DetailedScheduleLoading());
    final result = await getAllScheduleUseCase.call({});
    if (result is DataSuccess && result.data != null) {
      emit(DetailedScheduleLoaded(result.data!));
    } else {
      emit(DetailedScheduleError(result.message ?? 'Unknown error'));
    }
  }
}
