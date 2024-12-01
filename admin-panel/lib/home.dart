import 'package:conference_admin/features/about/presentation/pages/about_page.dart';
import 'package:conference_admin/features/article/presentation/pages/articles_page.dart';
import 'package:conference_admin/features/components/components_page.dart';
import 'package:conference_admin/features/detailed-schedule/presentation/pages/schedule_page.dart';
import 'package:conference_admin/features/home/presentation/pages/home_page.dart';
import 'package:conference_admin/features/imp-dates/presentation/pages/imp_dates_page.dart';
import 'package:conference_admin/features/navbar/navbar.dart';
import 'package:conference_admin/features/rewards/presentation/rewards_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:conference_admin/core/const/login_const.dart';
import 'package:conference_admin/features/users/presentation/pages/users_page.dart';

import 'package:conference_admin/routes.dart';
import 'package:responsive_builder/responsive_builder.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomePage(),
      const NavbarPage(),
      const AboutPage(),
      const SchedulePage(),
      const ImpDatesPage(),
      const RewardsPage(),
      const ArticlesPage(),
      const ComponentsPage(),
      const UsersPage(),
    ];

    final List<NavigationRailDestination> destinations = [
      NavigationRailDestination(
        icon: const Icon(Icons.home),
        label: const Text('Home'),
        selectedIcon: Icon(Icons.home, color: Colors.blue[800]),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.link),
        label: const Text('Navigation'),
        selectedIcon: Icon(Icons.link, color: Colors.blue[800]),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.people),
        label: const Text('About Page'),
        selectedIcon: Icon(Icons.people, color: Colors.blue[800]),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.calendar_month),
        label: const Text('Schedule'),
        selectedIcon: Icon(Icons.calendar_month, color: Colors.blue[800]),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.calendar_month),
        label: const Text('Important Dates'),
        selectedIcon: Icon(Icons.calendar_month, color: Colors.blue[800]),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.card_giftcard),
        label: const Text('Rewards'),
        selectedIcon: Icon(Icons.card_giftcard, color: Colors.blue[800]),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.article),
        label: const Text('Articles'),
        selectedIcon: Icon(Icons.article, color: Colors.blue[800]),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.link),
        label: const Text('Components'),
        selectedIcon: Icon(Icons.link, color: Colors.blue[800]),
      ),
      NavigationRailDestination(
        icon: const Icon(Icons.person),
        label: const Text('Users'),
        selectedIcon: Icon(Icons.person, color: Colors.blue[800]),
      ),
    ];

    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        final bool isMobile =
            sizingInfo.deviceScreenType == DeviceScreenType.mobile;
        return Scaffold(
          key: _scaffoldKey,
          appBar: _buildAppBar(isMobile),
          drawer: isMobile ? _buildSidebar(destinations) : null,
          body: Row(
            children: [
              if (!isMobile) _buildSidebar(destinations),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue[50]!,
                        Colors.purple[50]!,
                      ],
                    ),
                  ),
                  child: screens[currentIndex],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar(List<NavigationRailDestination> destinations) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'ADMIN PANEL',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ),
          Expanded(
            child: NavigationRail(
                selectedIndex: currentIndex,
                backgroundColor: Colors.white,
                extended: true,
                minExtendedWidth: 250,
                onDestinationSelected: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                  if (_scaffoldKey.currentState!.isDrawerOpen) {
                    Navigator.of(context).pop();
                  }
                },
                destinations: destinations),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isMobile) {
    return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: isMobile
            ? IconButton(
                icon: Icon(Icons.menu, color: Colors.blue[800]),
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              )
            : null,
        title: Text(
          'Welcome, ${LoginConst.currentUser?.name}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.blue[800]),
            onPressed: () {
              // Handle notifications
            },
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton.icon(
                  icon: const Icon(Icons.person),
                  label: const Text('Profile'),
                  onPressed: () {
                    Get.toNamed(Routes.profile);
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ))))
        ]);
  }
}
