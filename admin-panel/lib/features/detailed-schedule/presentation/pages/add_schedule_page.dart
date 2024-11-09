import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:conference_admin/features/detailed-schedule/data/models/detailed_schedule_model.dart';
import 'package:conference_admin/features/detailed-schedule/presentation/bloc/detailed_schedule_bloc.dart';

class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({super.key});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDate;
  final List<DayDetailModel> _dayDetails = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void _addDayDetail() {
    setState(() {
      _dayDetails.add(
        DayDetailModel(
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          description: '',
        ),
      );
    });
  }

  void _removeDayDetail(int index) {
    setState(() {
      _dayDetails.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<TimeOfDay?> _selectTime(
      BuildContext context, TimeOfDay initialTime) async {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Date: ${DateFormat('MMMM dd, yyyy').format(_selectedDate)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _dayDetails.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: const Text('Start Time'),
                                    subtitle: Text(
                                      DateFormat('hh:mm a')
                                          .format(_dayDetails[index].startTime),
                                    ),
                                    onTap: () async {
                                      final time = await _selectTime(
                                        context,
                                        TimeOfDay.fromDateTime(
                                            _dayDetails[index].startTime),
                                      );
                                      if (time != null) {
                                        setState(() {
                                          _dayDetails[index] =
                                              _dayDetails[index].copyWith(
                                            startTime: DateTime(
                                              _selectedDate.year,
                                              _selectedDate.month,
                                              _selectedDate.day,
                                              time.hour,
                                              time.minute,
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
                                    subtitle: Text(
                                      DateFormat('hh:mm a')
                                          .format(_dayDetails[index].endTime),
                                    ),
                                    onTap: () async {
                                      final time = await _selectTime(
                                        context,
                                        TimeOfDay.fromDateTime(
                                            _dayDetails[index].endTime),
                                      );
                                      if (time != null) {
                                        setState(() {
                                          _dayDetails[index] =
                                              _dayDetails[index].copyWith(
                                            endTime: DateTime(
                                              _selectedDate.year,
                                              _selectedDate.month,
                                              _selectedDate.day,
                                              time.hour,
                                              time.minute,
                                            ),
                                          );
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            TextFormField(
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
                                setState(() {
                                  _dayDetails[index] =
                                      _dayDetails[index].copyWith(
                                    description: value,
                                  );
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeDayDetail(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _addDayDetail,
                    child: const Text('Add Time Slot'),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _dayDetails.isNotEmpty) {
                        final schedule = DetailedScheduleModel(
                          id: DateTime.now().toString(),
                          date: _selectedDate,
                          dayDetails: _dayDetails,
                        );
                        context
                            .read<DetailedScheduleBloc>()
                            .add(AddDetailedScheduleEvent(schedule));
                        Get.back();
                      }
                    },
                    child: const Text('Save Schedule'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
