import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conference_admin/core/models/nav_bar_model.dart';
import 'package:conference_admin/features/pages/presentation/bloc/about_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

bool isRelatedToProgram() {
  String title = "Program";
  return title.toLowerCase().contains('dates'.toLowerCase()) ||
      title.toLowerCase().contains('schedule'.toLowerCase()) ||
      title.toLowerCase().contains('awards'.toLowerCase()) ||
      title.toLowerCase().contains('program'.toLowerCase());
}

Future<void> showAddPageDialog(BuildContext context, Function() callback,
    {NavItem? parent}) async {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController pathController = TextEditingController();
  final TextEditingController orderController = TextEditingController();
  final TextEditingController pageIdController = TextEditingController();
  bool isExternal = false;
  String? selectedPageId;

  await showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(parent == null
            ? 'Add Root Navigation Item'
            : 'Add Sub Navigation Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                key: const Key('titleField'),
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16, key: Key('spacing1')),
              TextField(
                key: const Key('pathField'),
                controller: pathController,
                decoration: const InputDecoration(
                  labelText: 'Path',
                  border: OutlineInputBorder(),
                  hintText: '/about or https://external-link.com',
                ),
              ),
              const SizedBox(height: 16, key: Key('spacing2')),
              TextField(
                key: const Key('orderField'),
                controller: orderController,
                decoration: const InputDecoration(
                  labelText: 'Order',
                  border: OutlineInputBorder(),
                  hintText: 'Enter display order (0-99)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16, key: Key('spacing3')),
              BlocBuilder<AboutBloc, AboutState>(
                builder: (context, state) {
                  if (state is AboutPagesLoaded) {
                    return DropdownButtonFormField<String>(
                      key: const Key('pageIdField'),
                      value: selectedPageId,
                      decoration: const InputDecoration(
                        labelText: 'About Page',
                        border: OutlineInputBorder(),
                      ),
                      items: state.pages.map((page) {
                        return DropdownMenuItem(
                          value: page.id,
                          child: Text(page.title),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPageId = value;
                          pageIdController.text = value ?? '';
                        });
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 16, key: Key('spacing4')),
              CheckboxListTile(
                key: const Key('externalCheckbox'),
                title: const Text('External Link'),
                value: isExternal,
                onChanged: (value) {
                  setState(() {
                    isExternal = value ?? false;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            key: const Key('cancelButton'),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            key: const Key('addButton'),
            onPressed: () async {
              if (titleController.text.isEmpty ||
                  pathController.text.isEmpty ||
                  orderController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }

              final newItem = NavItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: titleController.text,
                path: pathController.text,
                isExternal: isExternal,
                children: [],
                parentId: parent?.id,
                order: int.parse(orderController.text),
                pageId: pageIdController.text,
              );

              try {
                if (parent == null) {
                  await FirebaseFirestore.instance
                      .collection('navigation')
                      .doc(newItem.id)
                      .set(newItem.toJson());
                } else {
                  final parentDoc = await FirebaseFirestore.instance
                      .collection('navigation')
                      .doc(parent.id)
                      .get();
                  if (parentDoc.exists) {
                    final parentData = parentDoc.data()!;
                    final List<dynamic> children =
                        List.from(parentData['children'] ?? []);
                    children.add(newItem.toJson());
                    await FirebaseFirestore.instance
                        .collection('navigation')
                        .doc(parent.id)
                        .update({'children': children});
                  }
                }
                callback();
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error adding item: $e')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    ),
  );
}

Future<void> showEditPageDialog(
    BuildContext context, Function() callback, NavItem item) async {
  final TextEditingController titleController =
      TextEditingController(text: item.title);
  final TextEditingController pathController =
      TextEditingController(text: item.path);
  final TextEditingController orderController =
      TextEditingController(text: item.order.toString());
  final TextEditingController pageIdController =
      TextEditingController(text: item.pageId);
  bool isExternal = item.isExternal;
  String? selectedPageId = item.pageId;

  await showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Edit Navigation Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                key: const Key('editTitleField'),
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16, key: Key('editSpacing1')),
              TextField(
                key: const Key('editPathField'),
                controller: pathController,
                decoration: const InputDecoration(
                  labelText: 'Path',
                  border: OutlineInputBorder(),
                  hintText: '/about or https://external-link.com',
                ),
              ),
              const SizedBox(height: 16, key: Key('editSpacing2')),
              TextField(
                key: const Key('editOrderField'),
                controller: orderController,
                decoration: const InputDecoration(
                  labelText: 'Order',
                  border: OutlineInputBorder(),
                  hintText: 'Enter display order (0-99)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16, key: Key('editSpacing3')),
              BlocConsumer<AboutBloc, AboutState>(
                listener: (context, state) {
                  if (state is AboutInitial || state is AboutPagesError) {
                    context.read<AboutBloc>().add(GetPagesEvent());
                  }
                },
                builder: (context, state) {
                  if (state is AboutPagesLoaded) {
                    return Visibility(
                      visible: !isRelatedToProgram(),
                      child: DropdownButtonFormField<String>(
                        key: const Key('editPageIdField'),
                        value: selectedPageId,
                        decoration: const InputDecoration(
                          labelText: 'About Page',
                          border: OutlineInputBorder(),
                        ),
                        items: state.pages.map((page) {
                          return DropdownMenuItem(
                            value: page.id,
                            child: Text(page.title),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPageId = value;
                            pageIdController.text = value ?? '';
                          });
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 16, key: Key('editSpacing4')),
              CheckboxListTile(
                key: const Key('editExternalCheckbox'),
                title: const Text('External Link'),
                value: isExternal,
                onChanged: (value) {
                  setState(() {
                    isExternal = value ?? false;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            key: const Key('editCancelButton'),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            key: const Key('editSaveButton'),
            onPressed: () async {
              if (titleController.text.isEmpty ||
                  pathController.text.isEmpty ||
                  orderController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }

              try {
                final updatedItem = NavItem(
                  id: item.id,
                  title: titleController.text,
                  path: pathController.text,
                  isExternal: isExternal,
                  children: item.children,
                  parentId: item.parentId,
                  order: int.parse(orderController.text),
                  pageId: pageIdController.text,
                );

                if (item.parentId == null) {
                  await FirebaseFirestore.instance
                      .collection('navigation')
                      .doc(item.id)
                      .update(updatedItem.toJson());
                } else {
                  final parentDoc = await FirebaseFirestore.instance
                      .collection('navigation')
                      .doc(item.parentId)
                      .get();
                  if (parentDoc.exists) {
                    final parentData = parentDoc.data()!;
                    final List<dynamic> children =
                        List.from(parentData['children'] ?? []);
                    final index =
                        children.indexWhere((child) => child['id'] == item.id);
                    if (index != -1) {
                      children[index] = updatedItem.toJson();
                      await FirebaseFirestore.instance
                          .collection('navigation')
                          .doc(item.parentId)
                          .update({'children': children});
                    }
                  }
                }
                callback();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Navigation item updated successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating nav item: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
}

Future<void> deleteNavItem(
    BuildContext context, Function() callback, NavItem item) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    if (item.parentId == null) {
      // Delete root item
      await firestore.collection('navigation').doc(item.id).delete();
    } else {
      // Remove from parent's children array
      final parentDoc =
          await firestore.collection('navigation').doc(item.parentId).get();
      if (parentDoc.exists) {
        final parentData = parentDoc.data()!;
        final List<dynamic> children = List.from(parentData['children'] ?? []);
        children.removeWhere((child) => child['id'] == item.id);
        await firestore
            .collection('navigation')
            .doc(item.parentId)
            .update({'children': children});
      }
    }
    callback();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigation item deleted successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error deleting nav item: $e')),
    );
  }
}
