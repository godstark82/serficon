// ignore: depend_on_referenced_packages
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:conference_admin/features/article/data/models/article_model.dart';
import 'package:conference_admin/features/article/presentation/bloc/article_bloc.dart';

class AddArticlePage extends StatefulWidget {
  const AddArticlePage({super.key});

  @override
  _AddArticlePageState createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String documentType = '';
  String abstractString = '';
  List<String> mainSubjects = [];
  List<String> keywords = [];
  List<String> references = [];
  String pdf = '';
  String image = '';
  bool _isUploading = false;
  bool _isPdfUploading = false;
  String? selectedJournalId;
  String? selectedVolumeId;
  String? selectedIssueId;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Article'),
      ),
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          double horizontalPadding = sizingInformation.isDesktop ? 200.0 : 16.0;
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
                      onChanged: (v) => abstractString = v,
                      decoration: const InputDecoration(
                        labelText: 'Abstract',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an abstract';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Main Subjects (comma-separated)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter main subjects';
                        }
                        return null;
                      },
                      onChanged: (v) => mainSubjects =
                          v.split(',').map((e) => e.trim()).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      onChanged: (v) =>
                          keywords = v.split(',').map((e) => e.trim()).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Keywords (comma-separated)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter keywords';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      onChanged: (v) => references =
                          v.split(',').map((e) => e.trim()).toList(),
                      decoration: const InputDecoration(
                        labelText: 'References (comma-separated)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter references';
                        }
                        return null;
                      },
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['pdf'],
                                allowMultiple: false,
                                withData: true,
                              );

                              if (result != null && result.files.isNotEmpty) {
                                setState(() {
                                  _isPdfUploading = true;
                                  _uploadProgress = 0.0;
                                });

                                PlatformFile file = result.files.first;
                                if (file.bytes == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Failed to read file')),
                                  );
                                  setState(() {
                                    _isPdfUploading = false;
                                  });
                                  return;
                                }

                                String fileName =
                                    'article_${DateTime.now().millisecondsSinceEpoch}.pdf';

                                try {
                                  Reference ref = FirebaseStorage.instance
                                      .ref()
                                      .child('article_pdfs')
                                      .child(fileName);

                                  final metadata = SettableMetadata(
                                    contentType: 'application/pdf',
                                  );

                                  UploadTask uploadTask =
                                      ref.putData(file.bytes!, metadata);

                                  uploadTask.snapshotEvents.listen((snapshot) {
                                    setState(() {
                                      _uploadProgress = snapshot.bytesTransferred /
                                          snapshot.totalBytes;
                                    });
                                  }, onError: (error) {
                                    print('Upload error: $error');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Upload error: ${error.toString()}')),
                                    );
                                  });

                                  final snapshot = await uploadTask;
                                  final downloadUrl =
                                      await snapshot.ref.getDownloadURL();

                                  setState(() {
                                    pdf = downloadUrl;
                                    _isPdfUploading = false;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('PDF uploaded successfully')),
                                  );
                                } catch (e) {
                                  print('Error uploading PDF: $e');
                                  setState(() {
                                    _isPdfUploading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Upload failed: ${e.toString()}')),
                                  );
                                }
                              }
                            },
                            icon: _isPdfUploading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.upload_file, size: 18),
                            label: Text(_isPdfUploading
                                ? 'Uploading ${(_uploadProgress * 100).toStringAsFixed(1)}%'
                                : 'Upload PDF'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              minimumSize: const Size(120, 36),
                            ),
                          ),
                          if (_isPdfUploading) ...[
                            const SizedBox(height: 8),
                            LinearProgressIndicator(value: _uploadProgress),
                          ],
                          if (pdf.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Text(
                              'PDF uploaded',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () async {
                                if (await canLaunchUrl(Uri.parse(pdf))) {
                                  await launchUrl(Uri.parse(pdf));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Could not open PDF')),
                                  );
                                }
                              },
                              child: const Text('View PDF'),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                type: FileType.image,
                                allowMultiple: false,
                                withData: true,
                              );

                              if (result != null && result.files.isNotEmpty) {
                                setState(() {
                                  _isUploading = true;
                                });

                                PlatformFile file = result.files.first;
                                if (file.bytes == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Failed to read image')),
                                  );
                                  setState(() {
                                    _isUploading = false;
                                  });
                                  return;
                                }

                                String fileName =
                                    'image_${DateTime.now().millisecondsSinceEpoch}${file.extension}';

                                try {
                                  Reference ref = FirebaseStorage.instance
                                      .ref()
                                      .child('article_images')
                                      .child(fileName);

                                  final metadata = SettableMetadata(
                                    contentType: 'image/${file.extension}',
                                  );

                                  UploadTask uploadTask =
                                      ref.putData(file.bytes!, metadata);

                                  final snapshot = await uploadTask;
                                  final downloadUrl =
                                      await snapshot.ref.getDownloadURL();

                                  setState(() {
                                    image = downloadUrl;
                                    _isUploading = false;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Image uploaded successfully')),
                                  );
                                } catch (e) {
                                  print('Error uploading image: $e');
                                  setState(() {
                                    _isUploading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Upload failed: ${e.toString()}')),
                                  );
                                }
                              }
                            },
                            icon: _isUploading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.image, size: 18),
                            label: Text(
                                _isUploading ? 'Uploading...' : 'Upload Image'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              minimumSize: const Size(120, 36),
                            ),
                          ),
                          if (image.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Text(
                              'Image uploaded',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Image.network(
                              image,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            selectedJournalId != null &&
                            selectedVolumeId != null &&
                            selectedIssueId != null) {
                          final article = ArticleModel(
                            id: '',
                            author: 'admin',
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                            status: ArticleStatus.pending.value,
                            title: title,
                            documentType: documentType,
                            abstractString: abstractString,
                            mainSubjects: mainSubjects,
                            keywords: keywords,
                            references: references,
                            pdf: pdf,
                            image: image,
                          );
                          context
                              .read<ArticleBloc>()
                              .add(AddArticleEvent(article: article));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Article published successfully!'),
                              duration: Duration(seconds: 3),
                            ),
                          );

                          Get.back(result: true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please fill all required fields and upload a PDF'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      child: const Text('Submit Article'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
