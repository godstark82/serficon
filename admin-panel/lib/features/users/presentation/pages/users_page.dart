import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_admin/features/login/data/models/admin_model.dart';
import 'package:conference_admin/features/users/presentation/bloc/users_bloc.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersInitial) {
          context.read<UsersBloc>().add(GetUsersEvent());
          return const Center(child: CircularProgressIndicator());
        } else if (state is UsersLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UsersLoaded) {
          final admins = state.users?.toList() ?? [];

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Users'),
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  // Desktop layout
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                              width: constraints.maxWidth / 2 - 24,
                              child: _buildUserSection('Others', admins)),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Mobile layout
                  return ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      _buildUserSection('Others', admins),
                    ],
                  );
                }
              },
            ),
          );
        } else if (state is UsersLoadedSpecific) {
          final user = state.user;
          Widget userDetails;

          final genericUser = state.user as AdminModel;
          userDetails = buildGenericUserDetails(genericUser);

          return Scaffold(
            appBar: AppBar(
              title: const Text('${'Admin'} Details'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.read<UsersBloc>().add(GetUsersEvent()),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: _getUserColor(),
                            child: Text(
                              user?.name?.substring(0, 1).toUpperCase() ?? 'U',
                              style:
                                  const TextStyle(fontSize: 32, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        userDetails,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text('Something went wrong'));
        }
      },
    );
  }

  Widget _buildUserSection(String title, List<dynamic> users) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: users.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getUserColor(),
                  child: _getUserIcon(),
                ),
                title: Text(user.name ?? 'N/A',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.email ?? 'N/A'),
                  ],
                ),
                onTap: () {
                  context
                      .read<UsersBloc>()
                      .add(GetSpecificUserEvent(userId: user.id!));
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getUserColor() {
    return Colors.grey;
  }

  Icon _getUserIcon() {
    return const Icon(Icons.person, color: Colors.white);
  }
}

Widget buildGenericUserDetails(AdminModel user) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isDesktop = constraints.maxWidth > 600;
      return Card(
        elevation: 4,
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 16,
            children: [
              _buildDetailItem(
                  Icons.person,
                  'Name',
                  user.name,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
              _buildDetailItem(
                  Icons.email,
                  'Email',
                  user.email,
                  isDesktop
                      ? constraints.maxWidth / 2 - 24
                      : constraints.maxWidth - 32,
                  isDesktop),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildDetailItem(
    IconData icon, String label, String? value, double width, bool isDesktop) {
  return SizedBox(
    width: width,
    child: Row(
      mainAxisAlignment:
          isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: Colors.blue),
        const SizedBox(width: 10),
        Flexible(
          child: RichText(
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: value ?? 'N/A'),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
