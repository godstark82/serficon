import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_admin/features/imp-dates/data/models/date_model.dart';
import 'package:conference_admin/features/imp-dates/presentation/bloc/imp_dates_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateImpDatesPage extends StatefulWidget {
  const UpdateImpDatesPage({super.key});

  @override
  State<UpdateImpDatesPage> createState() => _UpdateImpDatesPageState();
}

class _UpdateImpDatesPageState extends State<UpdateImpDatesPage> {
  final _formKey = GlobalKey<FormState>();
  late List<TextEditingController> _dateControllers;
  late List<TextEditingController> _descriptionControllers;
  late List<DateModel> dateModels;

  @override
  void initState() {
    super.initState();
    dateModels = List<DateModel>.from(Get.arguments as List<DateModel>);
    _initializeControllers();
  }

  void _initializeControllers() {
    _dateControllers = dateModels
        .map((model) =>
            TextEditingController(text: _formatDate(model.date)))
        .toList();
    _descriptionControllers = dateModels
        .map((model) => TextEditingController(text: model.description ?? ''))
        .toList();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _selectDate(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_dateControllers[index].text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateControllers[index].text = _formatDate(picked);
      });
    }
  }

  void _addNewDate() {
    setState(() {
      dateModels.add(DateModel(date: DateTime.now(), description: ''));
      _dateControllers.add(TextEditingController(text: _formatDate(DateTime.now())));
      _descriptionControllers.add(TextEditingController());
    });
  }

  void _removeDate(int index) {
    setState(() {
      dateModels.removeAt(index);
      _dateControllers[index].dispose();
      _descriptionControllers[index].dispose();
      _dateControllers.removeAt(index);
      _descriptionControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (var controller in _dateControllers) {
      controller.dispose();
    }
    for (var controller in _descriptionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Important Dates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewDate,
            tooltip: 'Add New Date',
          ),
        ],
      ),
      body: BlocListener<ImpDatesBloc, ImpDatesState>(
        listener: (context, state) {
          if (state is ImpDatesUpdated) {
            Get.back();
            context.read<ImpDatesBloc>().add(GetDatesEvent());
          } else if (state is ImpDatesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView.builder(
              itemCount: dateModels.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.05),
                          Colors.white,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Date Entry ${index + 1}',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeDate(index),
                              tooltip: 'Remove Date',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => _selectDate(context, index),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _dateControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Select Date',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.calendar_today),
                                suffixIcon: Icon(Icons.arrow_drop_down,
                                    color: Theme.of(context).primaryColor),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a date';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionControllers[index],
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.description),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter event description...',
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              try {
                final updatedDates = List.generate(
                  dateModels.length,
                  (index) => DateModel(
                    date: DateFormat('yyyy-MM-dd').parse(_dateControllers[index].text),
                    description: _descriptionControllers[index].text,
                  ),
                );
                context.read<ImpDatesBloc>().add(
                      UpdateDatesEvent(dates: updatedDates),
                    );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid date format')),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          child: const Text(
            'Update All Dates',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
