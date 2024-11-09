import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conference_admin/features/committee/data/repositories/committee_repo_impl.dart';
import 'package:conference_admin/features/committee/domain/repositories/committee_repo.dart';
import 'package:conference_admin/features/committee/domain/usecases/add_member_usecase.dart';
import 'package:conference_admin/features/committee/domain/usecases/delete_member_usecase.dart';
import 'package:conference_admin/features/committee/domain/usecases/get_all_member_uc.dart';
import 'package:conference_admin/features/committee/domain/usecases/get_member_byid_uc.dart';
import 'package:conference_admin/features/committee/domain/usecases/update_member_uc.dart';
import 'package:conference_admin/features/committee/presentation/bloc/committee_bloc.dart';
import 'package:conference_admin/features/detailed-schedule/data/repositories/schedule_repo_impl.dart';
import 'package:conference_admin/features/detailed-schedule/domain/repositories/schedule_repo.dart';
import 'package:conference_admin/features/detailed-schedule/domain/usecases/add_schedule_uc.dart';
import 'package:conference_admin/features/detailed-schedule/domain/usecases/delete_schedule_uc.dart';
import 'package:conference_admin/features/detailed-schedule/domain/usecases/get_schedule_uc.dart';
import 'package:conference_admin/features/detailed-schedule/domain/usecases/get_single_schedule_uc.dart';
import 'package:conference_admin/features/detailed-schedule/domain/usecases/update_schedule_uc.dart';
import 'package:conference_admin/features/detailed-schedule/presentation/bloc/detailed_schedule_bloc.dart';
import 'package:conference_admin/features/faq/data/repositories/faq_repo_impl.dart';
import 'package:conference_admin/features/faq/domain/repositories/faq_repo.dart';
import 'package:conference_admin/features/faq/domain/usecases/add_review_uc.dart';
import 'package:conference_admin/features/faq/domain/usecases/add_submission_uc.dart';
import 'package:conference_admin/features/faq/domain/usecases/get_review_uc.dart';
import 'package:conference_admin/features/faq/domain/usecases/get_submission_uc.dart';
import 'package:conference_admin/features/faq/domain/usecases/update_review_uc.dart';
import 'package:conference_admin/features/faq/domain/usecases/update_submission_uc.dart';
import 'package:conference_admin/features/faq/presentation/bloc/faq_bloc.dart';
import 'package:conference_admin/features/home/data/repositories/home_repo_impl.dart';
import 'package:conference_admin/features/home/domain/repositories/home_repo.dart';
import 'package:conference_admin/features/home/domain/usecases/get_home_uc.dart';
import 'package:conference_admin/features/home/domain/usecases/update_hero_uc.dart';
import 'package:conference_admin/features/home/domain/usecases/update_publication_uc.dart';
import 'package:conference_admin/features/home/domain/usecases/update_scope_uc.dart';
import 'package:conference_admin/features/home/domain/usecases/update_stream_uc.dart';
import 'package:conference_admin/features/home/domain/usecases/update_wcu_uc.dart';
import 'package:conference_admin/features/home/domain/usecases/update_welcome_uc.dart';
import 'package:conference_admin/features/home/presentation/bloc/home_bloc.dart';
import 'package:conference_admin/features/imp-dates/data/repositories/date_repo_impl.dart';
import 'package:conference_admin/features/imp-dates/domain/repositories/date_repo.dart';
import 'package:conference_admin/features/imp-dates/domain/usecases/get_dates_uc.dart';
import 'package:conference_admin/features/imp-dates/domain/usecases/update_dates_uc.dart';
import 'package:conference_admin/features/imp-dates/presentation/bloc/imp_dates_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:conference_admin/features/login/data/repositories/login_repo_impl.dart';
import 'package:conference_admin/features/login/domain/repositories/login_repo.dart';
import 'package:conference_admin/features/login/domain/usecases/login_usecase.dart';
import 'package:conference_admin/features/login/domain/usecases/logout_usecase.dart';

import 'package:conference_admin/features/login/presentation/bloc/login_bloc.dart';
import 'package:conference_admin/features/users/data/repositories/users_repo_impl.dart';
import 'package:conference_admin/features/users/domain/repositories/users_repo.dart';
import 'package:conference_admin/features/users/domain/usecases/get_all_users_usecase.dart';
import 'package:conference_admin/features/users/domain/usecases/get_specific_user_usecase.dart';
import 'package:conference_admin/features/users/presentation/bloc/users_bloc.dart';
import 'package:conference_admin/core/services/login/login_service.dart';
import 'package:conference_admin/core/services/users_service.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //! Firebase
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  //! Services
  sl.registerSingleton<LoginService>(LoginService());
  sl.registerSingleton<UsersService>(UsersService());

  //! Repositories
  sl.registerSingleton<DateRepo>(DateRepoImpl(firestore: sl()));
  sl.registerSingleton<HomeRepo>(HomeRepoImpl(firestore: sl()));
  sl.registerSingleton<LoginRepo>(LoginRepoImpl(sl()));
  sl.registerSingleton<FaqRepo>(FaqRepoImpl());
  sl.registerSingleton<CommitteeRepo>(CommitteeRepoImpl());
  sl.registerSingleton<UsersRepo>(UsersRepoImpl(sl()));
  sl.registerSingleton<ScheduleRepo>(ScheduleRepoImpl());

  //! Usecases

  //? Home UseCases
  sl.registerSingleton<GetHomeUseCase>(GetHomeUseCase(sl()));
  sl.registerSingleton<UpdateHeroUseCase>(UpdateHeroUseCase(sl()));
  sl.registerSingleton<UpdateWcuUseCase>(UpdateWcuUseCase(sl()));
  sl.registerSingleton<UpdateScopeUseCase>(UpdateScopeUseCase(sl()));
  sl.registerSingleton<UpdateStreamUseCase>(UpdateStreamUseCase(sl()));
  sl.registerSingleton<UpdateWelcomeUseCase>(UpdateWelcomeUseCase(sl()));
  sl.registerSingleton<UpdatePublicationUseCase>(
      UpdatePublicationUseCase(sl()));

  //? Important Dates UseCases
  sl.registerSingleton<GetDatesUseCase>(GetDatesUseCase(sl()));
  sl.registerSingleton<UpdateDatesUseCase>(UpdateDatesUseCase(sl()));

  //? Faq UseCases
  sl.registerSingleton<GetReviewUseCase>(GetReviewUseCase(sl()));
  sl.registerSingleton<GetSubmissionUseCase>(GetSubmissionUseCase(sl()));
  sl.registerSingleton<AddReviewUseCase>(AddReviewUseCase(sl()));
  sl.registerSingleton<AddSubmissionUseCase>(AddSubmissionUseCase(sl()));
  sl.registerSingleton<UpdateReviewUseCase>(UpdateReviewUseCase(sl()));
  sl.registerSingleton<UpdateSubmissionUseCase>(UpdateSubmissionUseCase(sl()));

  //? Committee UseCases
  sl.registerSingleton<AddMemberUsecase>(AddMemberUsecase(sl()));
  sl.registerSingleton<DeleteMemberUsecase>(DeleteMemberUsecase(sl()));
  sl.registerSingleton<GetAllMemberUseCase>(GetAllMemberUseCase(sl()));
  sl.registerSingleton<GetMemberByidUseCase>(GetMemberByidUseCase(sl()));
  sl.registerSingleton<UpdateMemberUseCase>(UpdateMemberUseCase(sl()));

  //? Login Usecases
  sl.registerSingleton<LoginUsecase>(LoginUsecase(sl()));
  sl.registerSingleton<LogoutUsecase>(LogoutUsecase(sl()));
  sl.registerSingleton<GetAllUsersUseCase>(GetAllUsersUseCase(sl()));
  sl.registerSingleton<GetSpecificUserUsecase>(GetSpecificUserUsecase(sl()));

  //? Detailed Schedule Usecases
  sl.registerSingleton<GetAllScheduleUseCase>(GetAllScheduleUseCase(sl()));
  sl.registerSingleton<AddScheduleUseCase>(AddScheduleUseCase(sl()));
  sl.registerSingleton<UpdateScheduleUseCase>(UpdateScheduleUseCase(sl()));
  sl.registerSingleton<DeleteScheduleUseCase>(DeleteScheduleUseCase(sl()));
  sl.registerSingleton<GetSingleScheduleUseCase>(
      GetSingleScheduleUseCase(sl()));

  //! Blocs
  sl.registerFactory<HomeBloc>(
      () => HomeBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<ImpDatesBloc>(() => ImpDatesBloc(sl(), sl()));
  sl.registerFactory<FaqBloc>(
      () => FaqBloc(sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<CommitteeBloc>(
      () => CommitteeBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl(), sl(), sl()));
  sl.registerFactory<UsersBloc>(() => UsersBloc(sl(), sl()));
  sl.registerFactory<DetailedScheduleBloc>(
      () => DetailedScheduleBloc(sl(), sl(), sl(), sl(), sl()));
}
