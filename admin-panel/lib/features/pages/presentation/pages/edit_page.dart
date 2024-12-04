import 'package:conference_admin/features/pages/presentation/bloc/about_bloc.dart';
import 'package:conference_admin/features/pages/data/models/page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class EditAboutPage extends StatefulWidget {
  const EditAboutPage({super.key});

  @override
  State<EditAboutPage> createState() => _EditAboutPageState();
}

class _EditAboutPageState extends State<EditAboutPage> {
  final pageId = Get.parameters['id']!;
  final TextEditingController _titleController = TextEditingController();
  final HtmlEditorController _contentController = HtmlEditorController();
  final _formKey = GlobalKey<FormState>();
  String? _initialContent;

  @override
  void initState() {
    super.initState();
    context.read<AboutBloc>().add(GetPageEvent(pageId));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.disable();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final content = await _contentController.getText();
      if (content.isEmpty) return;

      final page = PagesModel(
          id: pageId,
          title: _titleController.text,
          htmlContent: content);

      context.read<AboutBloc>().add(UpdatePageEvent(page));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Page'),
      ),
      body: BlocConsumer<AboutBloc, AboutState>(
        listener: (context, state) {
          if (state is AboutSinglePageLoaded) {
            setState(() {
              _titleController.text = state.page.title;
              _initialContent = state.page.htmlContent;
            });
          }
        },
        builder: (context, state) {
          if (state is AboutPagesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AboutPagesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AboutBloc>().add(GetPageEvent(pageId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
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
                  if (_initialContent != null) // Only show editor once we have content
                    HtmlEditor(
                      controller: _contentController,
                      htmlEditorOptions: HtmlEditorOptions(
                        hint: 'Write your content here...',
                        initialText: _initialContent,
                      ),
                      callbacks: Callbacks(
                        onInit: () {
                          _contentController.setText(_initialContent ?? '');
                        },
                        onChangeContent: (String? changed) {
                          // Update the content whenever it changes
                          if (changed != null) {
                            _initialContent = changed;
                          }
                        },
                      ),
                    ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Update Page'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
