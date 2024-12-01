import 'package:conference_admin/features/about/presentation/bloc/about_bloc.dart';
import 'package:conference_admin/features/pages/data/models/pages_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAboutPage extends StatefulWidget {
  const AddAboutPage({super.key});

  @override
  State<AddAboutPage> createState() => _AddAboutPageState();
}

class _AddAboutPageState extends State<AddAboutPage> {
  final TextEditingController _titleController = TextEditingController();
  final HtmlEditorController _contentController = HtmlEditorController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedParentId;
  List<Map<String, dynamic>> _navigationItems = [];

  @override
  void initState() {
    super.initState();
    _loadNavigationItems();
  }

  Future<void> _loadNavigationItems() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('navigation').get();
      setState(() {
        _navigationItems = snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  'title': doc.data()['title'] as String,
                })
            .toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading navigation items: $e');
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.disable();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final page = PagesModel(
          id: "1",
          title: _titleController.text,
          htmlContent: await _contentController.getText(),
          parent: _selectedParentId);

      context.read<AboutBloc>().add(CreatePageEvent(page));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Parent Navigation',
                  border: OutlineInputBorder(),
                ),
                value: _selectedParentId,
                isExpanded: true,
                menuMaxHeight: 150,
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('Choose Parent'),
                  ),
                  ..._navigationItems
                      .where((item) => item['parentId'] == null)
                      .toList()
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item['id'],
                          child: Text(
                            item['title'],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedParentId = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              HtmlEditor(
                controller: _contentController,
                htmlEditorOptions: const HtmlEditorOptions(
                  hint: 'Write your content here...',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
