import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_admin/features/pages/presentation/bloc/pages_bloc.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:conference_admin/features/pages/data/models/pages_model.dart';

class CommitteeMemberPage extends StatefulWidget {
  const CommitteeMemberPage({super.key});

  @override
  State<CommitteeMemberPage> createState() => _CommitteeMemberPageState();
}

class _CommitteeMemberPageState extends State<CommitteeMemberPage> {
  @override
  void initState() {
    super.initState();
    context.read<PagesBloc>().add(GetPagesEvent());
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
                      // if (mounted) {
                      context.read<PagesBloc>().add(UpdatePageEvent(updatedPage));
                      Navigator.pop(context);
                      // }
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
      body: BlocBuilder<PagesBloc, PagesState>(
        builder: (context, state) {
          if (state is PageLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PageError) {
            return Center(child: Text(state.message));
          }
          if (state is PagesLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Committee Pages',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        _buildPageCard(
                          'Organizing Committee',
                          state.pages['oc']!.htmlContent,
                          () => _showEditDialog(state.pages['oc']!),
                        ),
                        _buildPageCard(
                          'Scientific Committee Member',
                          state.pages['scm']!.htmlContent,
                          () => _showEditDialog(state.pages['scm']!),
                        ),
                        _buildPageCard(
                          'Scientific Lead',
                          state.pages['sl']!.htmlContent,
                          () => _showEditDialog(state.pages['sl']!),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildPageCard(String title, String content, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onTap,
              child: const Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }
}
