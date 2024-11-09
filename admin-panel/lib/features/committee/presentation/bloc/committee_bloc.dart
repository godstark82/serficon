import 'package:bloc/bloc.dart';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:conference_admin/features/committee/data/models/committee_member_model.dart';
import 'package:conference_admin/features/committee/domain/usecases/add_member_usecase.dart';
import 'package:conference_admin/features/committee/domain/usecases/delete_member_usecase.dart';
import 'package:conference_admin/features/committee/domain/usecases/get_all_member_uc.dart';
import 'package:conference_admin/features/committee/domain/usecases/get_member_byid_uc.dart';
import 'package:conference_admin/features/committee/domain/usecases/update_member_uc.dart';
import 'package:equatable/equatable.dart';

part 'committee_event.dart';
part 'committee_state.dart';

class CommitteeBloc extends Bloc<CommitteeEvent, CommitteeState> {
  final AddMemberUsecase addMemberUsecase;
  final DeleteMemberUsecase deleteMemberUsecase;
  final GetAllMemberUseCase getAllMemberUseCase;
  final GetMemberByidUseCase getMemberByidUseCase;
  final UpdateMemberUseCase updateMemberUseCase;
  CommitteeBloc(
      this.addMemberUsecase,
      this.deleteMemberUsecase,
      this.getAllMemberUseCase,
      this.getMemberByidUseCase,
      this.updateMemberUseCase)
      : super(CommitteeInitial()) {
    on<AddCommitteeMemberEvent>(onAddMember);
    on<GetAllCommitteeMembersEvent>(onGetAllMembers);
    on<GetCMemberByIdEvent>(onGetMemberById);
    on<UpdateCommitteeMemberEvent>(onUpdateMember);
    on<DeleteCommitteeMemberEvent>(onDeleteMember);
  }

  //! onCreate
  void onAddMember(
      AddCommitteeMemberEvent event, Emitter<CommitteeState> emit) async {
    await addMemberUsecase.call(event.member);
    add(GetAllCommitteeMembersEvent());
  }

  //! READ
  void onGetAllMembers(
      GetAllCommitteeMembersEvent event, Emitter<CommitteeState> emit) async {
    emit(LoadingAllCommitteeState());
    final data = await getAllMemberUseCase.call({});
    if (data is DataSuccess && data.data != null) {
      emit(LoadedAllCommitteeState(data.data!));
    } else if (data.data != null && data.data!.isNotEmpty) {
      emit(const ErrorAllCommitteeMember('No Member Found'));
    } else {
      emit(const ErrorAllCommitteeMember('Error Occurred'));
    }
  }

  void onGetMemberById(
      GetCMemberByIdEvent event, Emitter<CommitteeState> emit) async {
    emit(LoadingSingleCommitteeState());
    final data = await getMemberByidUseCase.call(event.id);
    if (data is DataSuccess && data.data != null) {
      emit(LoadedSingleCommitteeState(data.data!));
    } else if (data.data == null) {
      emit(const ErrorSingleCommitteeMember('No Member Found'));
    } else {
      emit(const ErrorSingleCommitteeMember('Error Occurred'));
    }
  }

  //! Update
  void onUpdateMember(
      UpdateCommitteeMemberEvent event, Emitter<CommitteeState> emit) async {
    await updateMemberUseCase.call(event.member);
    add(GetAllCommitteeMembersEvent());
  }

  //! Delete
  void onDeleteMember(
      DeleteCommitteeMemberEvent event, Emitter<CommitteeState> emit) async {
    await deleteMemberUsecase.call(event.id);
    add(GetAllCommitteeMembersEvent());
  }
}
