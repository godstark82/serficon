import 'package:conference_admin/features/committee/presentation/pages/add_member_page.dart';
import 'package:conference_admin/features/committee/presentation/pages/update_member_page.dart';
import 'package:conference_admin/features/detailed-schedule/presentation/pages/add_schedule_page.dart';
import 'package:conference_admin/features/detailed-schedule/presentation/pages/update_schedule_page.dart';
import 'package:conference_admin/features/faq/presentation/pages/update_review_page.dart';
import 'package:conference_admin/features/faq/presentation/pages/update_submission_page.dart';
import 'package:conference_admin/features/imp-dates/presentation/pages/imp_dates_page.dart';
import 'package:conference_admin/features/imp-dates/presentation/pages/update_dates_page.dart';
import 'package:get/get.dart';
import 'package:conference_admin/core/common/screens/profile.dart';
import 'package:conference_admin/core/usecase/middleware.dart';
import 'package:conference_admin/home.dart';
import 'package:conference_admin/features/login/presentation/pages/login_page.dart';

class Routes {
  //login related
  static const String login = '/login';

  //dashboard related
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String homePageManage = '/home_page_manage';
  //ADMIN
  // Pages
  static const String pages = '/pages';
  static const String addPage = '/add_page';
  static const String editPage = '/edit_page';
  static const String allPages = '/all_pages';

  // Committee Member
  static const String addCommitteeMember = '/add-committee-member';
  static const String updateCommitteeMember = '/update-committee-member';

  // Detailed Schedule
  static const String addDetailedSchedule = '/add-detailed-schedule';
  static const String updateDetailedSchedule = '/update-detailed-schedule';

  // FAQ
  static const String updateReview = '/update-review';
  static const String addSubmission = '/add-submission';
  static const String updateSubmission = '/update-submission';

  // Important Dates
  static const String impDates = '/imp-dates';
  static const String updateImpDates = '/update-imp-dates';
}

List<GetPage> routes = [
  GetPage(
      name: Routes.dashboard,
      middlewares: [AuthGuard()],
      page: () => const Home()),

  //! ADMIN BASED ROUTES

  //! Login Page Initial Page
  GetPage(name: Routes.login, page: () => const LoginPage()),
  GetPage(
    name: Routes.profile,
    page: () => const ProfilePage(),
    middlewares: [AuthGuard()],
  ),

  //! Committee Member
  GetPage(
      name: Routes.dashboard + Routes.addCommitteeMember,
      page: () => const AddMemberPage(),
      middlewares: [AuthGuard()]),
  GetPage(
      name: Routes.dashboard + Routes.updateCommitteeMember,
      page: () => const UpdateMemberPage(),
      middlewares: [AuthGuard()]),

  // Detailed Schedule
  GetPage(
      name: Routes.dashboard + Routes.addDetailedSchedule,
      page: () => const AddSchedulePage(),
      middlewares: [AuthGuard()]),
  GetPage(
      name: Routes.dashboard + Routes.updateDetailedSchedule,
      page: () => const UpdateSchedulePage(),
      middlewares: [AuthGuard()]),

  // FAQ
  GetPage(
      name: Routes.dashboard + Routes.updateReview,
      page: () => const UpdateReviewPage(),
      middlewares: [AuthGuard()]),
  GetPage(
      name: Routes.dashboard + Routes.updateSubmission,
      page: () => const UpdateSubmissionPage(),
      middlewares: [AuthGuard()]),

  // Important Dates
  GetPage(
      name: Routes.dashboard + Routes.impDates,
      page: () => const ImpDatesPage(),
      middlewares: [AuthGuard()]),
  GetPage(
      name: Routes.dashboard + Routes.updateImpDates,
      page: () => const UpdateImpDatesPage(),
      middlewares: [AuthGuard()]),
];
