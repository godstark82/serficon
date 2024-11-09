import 'package:conference_admin/features/detailed-schedule/presentation/bloc/detailed_schedule_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_admin/features/detailed-schedule/data/models/detailed_schedule_model.dart';
import 'package:get/get.dart';

class UpdateSchedulePage extends StatefulWidget {
  const UpdateSchedulePage({super.key});

  @override
  State<UpdateSchedulePage> createState() => _UpdateSchedulePageState();
}

class _UpdateSchedulePageState extends State<UpdateSchedulePage> {
  final String scheduleId = Get.parameters['id'] ?? '';
  late DateTime selectedDate;
  final List<DayDetailModel> dayDetails = [];
  final _formKey = GlobalKey<FormState>();
  late DetailedScheduleModel schedule;

  @override
  void initState() {
    super.initState();
    context
        .read<DetailedScheduleBloc>()
        .add(GetSingleDetailedScheduleEvent(scheduleId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Schedule'),
      ),
      body: BlocConsumer<DetailedScheduleBloc, DetailedScheduleState>(
        listener: (context, state) {
          if (state is DetailedScheduleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is SingleDetailedScheduleLoaded) {
            setState(() {
              schedule = state.detailedSchedule;
              selectedDate = schedule.date;
              dayDetails.clear();
              dayDetails.addAll(
                  schedule.dayDetailsListEntityToModel(schedule.dayDetails));
            });
          }
        },
        builder: (context, state) {
          if (state is DetailedScheduleLoading ||
              state is DetailedScheduleInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SingleDetailedScheduleLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: const Text('Schedule Date'),
                      subtitle: Text(selectedDate.toString().split(' ')[0]),
                      trailing: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...dayDetails.asMap().entries.map((entry) {
                      final index = entry.key;
                      final detail = entry.value;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: detail.description,
                                      decoration: const InputDecoration(
                                        labelText: 'Description',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a description';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        dayDetails[index] = detail.copyWith(
                                          description: value,
                                        );
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        dayDetails.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      title: const Text('Start Time'),
                                      subtitle:
                                          Text(detail.startTime.toString()),
                                      onTap: () async {
                                        final TimeOfDay? picked =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.fromDateTime(
                                              detail.startTime),
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            dayDetails[index] = detail.copyWith(
                                              startTime: DateTime(
                                                detail.startTime.year,
                                                detail.startTime.month,
                                                detail.startTime.day,
                                                picked.hour,
                                                picked.minute,
                                              ),
                                            );
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: const Text('End Time'),
                                      subtitle: Text(detail.endTime.toString()),
                                      onTap: () async {
                                        final TimeOfDay? picked =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.fromDateTime(
                                              detail.endTime),
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            dayDetails[index] = detail.copyWith(
                                              endTime: DateTime(
                                                detail.endTime.year,
                                                detail.endTime.month,
                                                detail.endTime.day,
                                                picked.hour,
                                                picked.minute,
                                              ),
                                            );
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          dayDetails.add(
                            DayDetailModel(
                              startTime: DateTime.now(),
                              endTime:
                                  DateTime.now().add(const Duration(hours: 1)),
                              description: '',
                            ),
                          );
                        });
                      },
                      child: const Text('Add Time Slot'),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final updatedSchedule = schedule.copyWith(
                              date: selectedDate,
                              dayDetails: dayDetails,
                            );
                            context.read<DetailedScheduleBloc>().add(
                                UpdateDetailedScheduleEvent(updatedSchedule));
                            Get.back();
                          }
                        },
                        child: const Text('Update Schedule'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
