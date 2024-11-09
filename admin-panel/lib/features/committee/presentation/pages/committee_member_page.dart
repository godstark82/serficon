import 'package:conference_admin/features/committee/presentation/bloc/committee_bloc.dart';
import 'package:conference_admin/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CommitteeMemberPage extends StatefulWidget {
  const CommitteeMemberPage({super.key});

  @override
  State<CommitteeMemberPage> createState() => _CommitteeMemberPageState();
}

class _CommitteeMemberPageState extends State<CommitteeMemberPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommitteeBloc>().add(GetAllCommitteeMembersEvent());
    });
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'advisor':
        return Colors.blue.shade100;
      case 'organizer':
        return Colors.green.shade100;
      case 'volunteer':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Committee Members'),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(Routes.dashboard + Routes.addCommitteeMember);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: BlocBuilder<CommitteeBloc, CommitteeState>(
        builder: (context, state) {
          if (state is LoadingAllCommitteeState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoadedAllCommitteeState) {
            final members = state.members;
            if (members.isEmpty) {
              return const Center(child: Text('No committee members found'));
            }
            
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: _getRoleColor(member.role.value),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(member.image),
                                radius: 30,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      member.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      member.role.value,
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (member.designation.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        member.designation,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ]
                                )
                              )
                            ]
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  Get.toNamed(
                                      Routes.dashboard +
                                          Routes.updateCommitteeMember,
                                      parameters: {'memberId': member.id});
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('Update'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Member'),
                                      content: Text(
                                          'Are you sure you want to delete ${member.name}?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context.read<CommitteeBloc>().add(
                                                DeleteCommitteeMemberEvent(
                                                    member.id));
                                            Navigator.pop(context);
                                          },
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.red,
                                          ),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.delete),
                                label: const Text('Delete'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is ErrorAllCommitteeMember) {
            return Center(child: Text(state.msg));
          }
          return const Center(child: Text('Please wait...'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<CommitteeBloc>().add(GetAllCommitteeMembersEvent());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
