import 'package:conference_admin/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_admin/features/imp-dates/presentation/bloc/imp_dates_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ImpDatesPage extends StatefulWidget {
  const ImpDatesPage({super.key});

  @override
  State<ImpDatesPage> createState() => _ImpDatesPageState();
}

class _ImpDatesPageState extends State<ImpDatesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ImpDatesBloc>().add(GetDatesEvent());
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'No Date';
    return DateFormat('dd-MMMM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Important Dates',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: BlocBuilder<ImpDatesBloc, ImpDatesState>(
          builder: (context, state) {
            if (state is ImpDatesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ImpDatesError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (state is ImpDatesLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: ListView.builder(
                      itemCount: state.dates.length,
                      itemBuilder: (context, index) {
                        final date = state.dates[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                            ),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Center(
                                    child: Text(
                                      formatDate(date.date),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      date.description ?? 'No Description',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }
            return const Center(
              child: Text(
                'No dates available',
                style: TextStyle(fontSize: 16),
              ),
            );
          },
        ),
      ),
      floatingActionButton: BlocBuilder<ImpDatesBloc, ImpDatesState>(
        builder: (context, state) {
          if (state is ImpDatesLoaded) {
            return FloatingActionButton.extended(
              onPressed: () {
                Get.toNamed(Routes.dashboard + Routes.updateImpDates,
                    arguments: state.dates);
              },
              icon: const Icon(Icons.update),
              label: const Text('Update Dates'),
              backgroundColor: Theme.of(context).primaryColor,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
