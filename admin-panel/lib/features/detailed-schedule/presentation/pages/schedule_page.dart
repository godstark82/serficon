import 'package:conference_admin/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:conference_admin/features/detailed-schedule/presentation/bloc/detailed_schedule_bloc.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  void initState() {
    context.read<DetailedScheduleBloc>().add(GetDetailedScheduleEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Conference Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.toNamed(Routes.dashboard + Routes.addDetailedSchedule);
            },
          ),
        ],
      ),
      body: BlocBuilder<DetailedScheduleBloc, DetailedScheduleState>(
        builder: (context, state) {
          if (state is DetailedScheduleLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DetailedScheduleError) {
            return Center(child: Text(state.message));
          }

          if (state is DetailedScheduleLoaded) {
            final schedules = state.detailedSchedules;

            return LayoutBuilder(builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: schedules.map((schedule) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Schedule for ${DateFormat('MMMM dd, yyyy').format(schedule.date)}',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          // Handle edit
                                          Get.toNamed(
                                              Routes.dashboard +
                                                  Routes.updateDetailedSchedule,
                                              parameters: {'id': schedule.id});
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          // Show confirmation dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Confirm Delete'),
                                                content: const Text(
                                                    'Are you sure you want to delete this schedule?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      context
                                                          .read<
                                                              DetailedScheduleBloc>()
                                                          .add(
                                                              DeleteDetailedScheduleEvent(
                                                                  schedule.id));
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: constraints.maxWidth,
                                child: DataTable(
                                  columnSpacing: constraints.maxWidth * 0.1,
                                  columns: const [
                                    DataColumn(label: Text('Start Time')),
                                    DataColumn(label: Text('End Time')),
                                    DataColumn(label: Text('Description')),
                                  ],
                                  rows: schedule.dayDetails.map((detail) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(DateFormat('hh:mm a')
                                            .format(detail.startTime))),
                                        DataCell(Text(DateFormat('hh:mm a')
                                            .format(detail.endTime))),
                                        DataCell(Text(detail.description)),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              );
            });
          }

          return const Center(child: Text('No schedule found'));
        },
      ),
    );
  }
}
