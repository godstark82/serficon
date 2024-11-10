import 'dart:developer';

import 'package:conference_admin/features/committee/presentation/bloc/committee_bloc.dart';
import 'package:conference_admin/features/detailed-schedule/presentation/bloc/detailed_schedule_bloc.dart';
import 'package:conference_admin/features/faq/presentation/bloc/faq_bloc.dart';
import 'package:conference_admin/features/home/presentation/bloc/home_bloc.dart';
import 'package:conference_admin/features/imp-dates/presentation/bloc/imp_dates_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:conference_admin/core/const/login_const.dart';
import 'package:conference_admin/dependency_injection.dart';
import 'package:conference_admin/features/login/presentation/bloc/login_bloc.dart';
import 'package:conference_admin/features/login/presentation/pages/login_page.dart';
import 'package:conference_admin/features/users/presentation/bloc/users_bloc.dart';
import 'package:conference_admin/firebase_options.dart';
import 'package:conference_admin/routes.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('cache');
  await initializeDependencies();
  await LoginConst.getCurrentUser();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(create: (context) => sl<HomeBloc>()),
          BlocProvider<ImpDatesBloc>(create: (context) => sl<ImpDatesBloc>()),
          BlocProvider<LoginBloc>(create: (context) => sl<LoginBloc>()),
          BlocProvider<UsersBloc>(create: (context) => sl<UsersBloc>()),
          BlocProvider<CommitteeBloc>(create: (context) => sl<CommitteeBloc>()),
          BlocProvider<DetailedScheduleBloc>(
              create: (context) => sl<DetailedScheduleBloc>()),
          BlocProvider<FaqBloc>(create: (context) => sl<FaqBloc>()),
        ],
        child: GetMaterialApp(
          defaultTransition: Get.defaultTransition,
          transitionDuration: const Duration(milliseconds: 300),
          debugShowCheckedModeBanner: false,
          home: const LoginPage(),
          initialRoute: Routes.login,
          getPages: routes,
        ));
  }
}
