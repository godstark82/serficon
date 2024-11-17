import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_admin/features/pages/presentation/bloc/pages_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:conference_admin/features/pages/data/models/pages_model.dart';

class ReviewProcessPage extends StatefulWidget {
  const ReviewProcessPage({super.key});

  @override
  State<ReviewProcessPage> createState() => _ReviewProcessPageState();
}

class _ReviewProcessPageState extends State<ReviewProcessPage> {
  @override
  void initState() {
    super.initState();
    context.read<PagesBloc>().add(const GetPageByIdEvent('review_process'));
  }

  void _showEditDialog(PagesModel page) {
    final titleController = TextEditingController(text: page.title);
    final htmlController = HtmlEditorController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: HtmlEditor(
                  controller: htmlController,
                  htmlEditorOptions: HtmlEditorOptions(
                    initialText: page.htmlContent,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final htmlContent = await htmlController.getText();
                      final updatedPage = PagesModel(
                        id: page.id,
                        title: titleController.text,
                        htmlContent: htmlContent,
                      );
                      context
                          .read<PagesBloc>()
                          .add(UpdatePageEvent(updatedPage));
                      // Fetch updated data after update
                      context
                          .read<PagesBloc>()
                          .add(const GetPageByIdEvent('review_process'));
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PagesBloc, PagesState>(
        listener: (context, state) {
          if (state is PageByIdError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update page')),
            );
          }
          if (state is PageByIdLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Page fetched successfully')),
            );
          }
        },
        builder: (context, state) {
          if (state is PageByIdLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PageByIdLoaded) {
            final page = state.page;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        page.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      ElevatedButton(
                        onPressed: () => _showEditDialog(page),
                        child: const Text('Update'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  HtmlWidget(page.htmlContent),
                ],
              ),
            );
          } else if (state is PageByIdError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
