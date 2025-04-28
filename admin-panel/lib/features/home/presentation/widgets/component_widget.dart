import 'package:conference_admin/features/home/data/models/home_component_model.dart';
import 'package:conference_admin/features/home/domain/entities/home_component_entity.dart';
import 'package:conference_admin/features/home/presentation/bloc/home_bloc.dart';
import 'package:conference_admin/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

class HomeComponentWidget extends StatelessWidget {
  final HomeComponentModel component;
  const HomeComponentWidget({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.1),
                Colors.purple.withOpacity(0.1)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  component.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Get.toNamed(Routes.dashboard + Routes.updateComponent,
                            parameters: {'id': component.id});
                      },
                      color: Colors.blue,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: component.display
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        component.display ? 'Visible' : 'Hidden',
                        style: TextStyle(
                          color: component.display
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: component.display,
                      onChanged: (value) {
                        context.read<HomeBloc>().add(
                              UpdateDisplayEvent(
                                component.id,
                                value,
                              ),
                            );
                      },
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'HTML Content:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: HtmlWidget(component.htmlContent ?? ''),
            ),
            const SizedBox(height: 16),
            if (component.type == HomeComponentType.withCards &&
                component.cards != null)
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Cards',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                            const Divider(),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.6,
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: component.cards!.length,
                                itemBuilder: (context, index) {
                                  final card = component.cards![index];
                                  return Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: ListTile(
                                      leading: card.image != null &&
                                              card.image!.isNotEmpty &&
                                              card.image!.startsWith('http')
                                          ? Image.network(
                                              card.image!,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            )
                                          : const Icon(Icons.image),
                                      title: Text(card.title ?? ''),
                                      subtitle: Text(card.description ?? ''),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.grid_view),
                label: Text('View ${component.cards!.length} Cards'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade100,
                  foregroundColor: Colors.blue.shade900,
                ),
              ),
            if (component.type == HomeComponentType.withStream &&
                component.streamCards != null)
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Stream Cards',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                            const Divider(),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.6,
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: component.streamCards!.length,
                                itemBuilder: (context, index) {
                                  final stream = component.streamCards![index];
                                  return Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: ListTile(
                                      title: Text(stream.title ?? ''),
                                      subtitle: Text(
                                          stream.descriptions?.join(', ') ??
                                              ''),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.play_circle_outline),
                label:
                    Text('View ${component.streamCards!.length} Stream Cards'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade100,
                  foregroundColor: Colors.purple.shade900,
                ),
              ),
          ],
        ));
  }
}
