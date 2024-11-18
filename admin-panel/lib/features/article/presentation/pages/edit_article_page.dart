// ignore: depend_on_referenced_packages
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:conference_admin/features/article/presentation/bloc/article_bloc.dart';
import 'package:conference_admin/routes.dart';

class EditArticlePage extends StatefulWidget {
  const EditArticlePage({super.key});

  @override
  _EditArticlePageState createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {
  final String articleId = Get.parameters['articleId'] ?? '';

  final _formKey = GlobalKey<FormState>();
  late String title = '';
  late String documentType = '';
  late String abstractString = '';
  late List<String> mainSubjects = [];
  late List<String> keywords = [];
  late List<String> references = [];
  late String pdf = '';
  late String image = '';
  late String author = '';
  double _uploadProgress = 0.0;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _uploadPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
      });

      PlatformFile file = result.files.first;
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.pdf';

      try {
        final ref = FirebaseStorage.instance.ref().child('pdfs/$fileName');
        final uploadTask = ref.putData(
          file.bytes!,
          SettableMetadata(contentType: 'application/pdf'),
        );

        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
          });
        });

        await uploadTask;

        String downloadURL = await ref.getDownloadURL();
        setState(() {
          pdf = downloadURL;
          _isUploading = false;
        });
      } catch (e) {
        print('Error uploading PDF: $e');
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Article'),
      ),
      body: BlocBuilder<ArticleBloc, ArticleState>(
        builder: (context, state) {
          if (state is ArticleByIdLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ArticleByIdLoadedState) {
            final article = state.article;
            title = article.title;
            documentType = article.documentType;
            abstractString = article.abstractString;
            mainSubjects = article.mainSubjects;
            keywords = article.keywords;
            references = article.references;
            pdf = article.pdf;
            image = article.image;
            author = article.author;

            return ResponsiveBuilder(
              builder: (context, sizingInformation) {
                double horizontalPadding =
                    sizingInformation.isDesktop ? 200.0 : 16.0;
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 16.0,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16),
                          TextFormField(
                            initialValue: title,
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
                            onChanged: (v) => title = v,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            initialValue: documentType,
                            decoration: const InputDecoration(
                              labelText: 'Document Type',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a document type';
                              }
                              return null;
                            },
                            onChanged: (v) => documentType = v,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            initialValue: abstractString,
                            decoration: const InputDecoration(
                              labelText: 'Abstract',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an abstract';
                              }
                              return null;
                            },
                            onChanged: (v) => abstractString = v,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            initialValue: mainSubjects.join(', '),
                            decoration: const InputDecoration(
                              labelText: 'Main Subjects (comma-separated)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter at least one main subject';
                              }
                              return null;
                            },
                            onChanged: (v) => mainSubjects =
                                v.split(',').map((e) => e.trim()).toList(),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            initialValue: keywords.join(', '),
                            decoration: const InputDecoration(
                              labelText: 'Keywords (comma-separated)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter at least one keyword';
                              }
                              return null;
                            },
                            onChanged: (v) => keywords =
                                v.split(',').map((e) => e.trim()).toList(),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            initialValue: references.join('\n'),
                            decoration: const InputDecoration(
                              labelText: 'References (one per line)',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter at least one reference';
                              }
                              return null;
                            },
                            onChanged: (v) => references =
                                v.split('\n').map((e) => e.trim()).toList(),
                          ),
                          const SizedBox(height: 16),
                          if (_isUploading)
                            LinearProgressIndicator(value: _uploadProgress)
                          else if (pdf.isNotEmpty)
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (await canLaunchUrl(Uri.parse(pdf))) {
                                      await launchUrl(Uri.parse(pdf));
                                    }
                                  },
                                  child: const Text('View PDF'),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: _uploadPDF,
                                  child: const Text('Change PDF'),
                                ),
                              ],
                            )
                          else
                            ElevatedButton(
                              onPressed: _uploadPDF,
                              child: const Text('Upload PDF'),
                            ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: image.isNotEmpty
                                    ? Image.network(image, height: 100)
                                    : const Text('No image uploaded'),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () async {
                                  // Implement image upload logic
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                                child: const Text('Change Image'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final updatedArticle = article.copyWith(
                                  author: author,
                                  title: title,
                                  documentType: documentType,
                                  abstractString: abstractString,
                                  mainSubjects: mainSubjects,
                                  keywords: keywords,
                                  references: references,
                                  pdf: pdf,
                                  image: image,
                                  updatedAt: DateTime.now(),
                                );
                                context.read<ArticleBloc>().add(
                                    EditArticleEvent(article: updatedArticle));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Article updated successfully!'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                                Get.offNamed(Routes.dashboard,
                                    parameters: {'i': 'a'});
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Please fill all required fields'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            child: const Text('Update Article'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Failed to load article'));
          }
        },
      ),
    );
  }
}
