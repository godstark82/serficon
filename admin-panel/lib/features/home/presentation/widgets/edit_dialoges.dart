import 'package:conference_admin/core/models/card_model.dart';
import 'package:conference_admin/core/models/stream_card_model.dart';
import 'package:conference_admin/core/services/firebase_storage_services.dart';
import 'package:conference_admin/features/home/presentation/widgets/sections.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class EditDialog extends StatelessWidget {
  final String title;
  final Map<String, dynamic> fields;
  final Function(Map<String, dynamic>) onSave;

  const EditDialog({
    super.key,
    required this.title,
    required this.fields,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final textFields = Map<String, dynamic>.from(fields.map<String, dynamic>(
        (key, value) => MapEntry(key, value is bool ? '' : value.toString())));

    final controllers = textFields.map<String, dynamic>(
      (key, value) => MapEntry(key, TextEditingController(text: value)),
    );

    bool isUploading = false;
    bool showImage = fields['Show Image'] ?? true;

    return Dialog(
      child: StatefulBuilder(
        builder: (context, setState) => Scaffold(
          appBar: AppBar(
            title: Text('Edit $title'),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  final values = controllers.map(
                    (key, controller) => MapEntry(key, controller.text),
                  );
                  values['Show Image'] = showImage;
                  onSave(values);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: controllers.entries.map((entry) {
                if (entry.key == 'Title') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: entry.value,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: entry.key,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  );
                } else if (entry.key == 'Image URL') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text('Image',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                const Text('Show Image'),
                                Switch(
                                  value: showImage,
                                  onChanged: (value) {
                                    setState(() {
                                      showImage = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: entry.value.text.isEmpty 
                                ? const Text(
                                    'No image uploaded',
                                    style: TextStyle(color: Colors.red),
                                  )
                                : SelectableText(
                                    entry.value.text,
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                    ),
                                  ),
                            ),
                         
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isUploading = true;
                                });
                                final downloadUrl =
                                    await FirebaseStorageServices
                                        .pickAndUploadImage();
                                entry.value.text = downloadUrl;
                                setState(() {
                                  isUploading = false;
                                });
                              },
                              child: isUploading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Upload Image'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (entry.key != 'Show Image') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.key,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        HtmlEditor(
                          controller: HtmlEditorController(),
                          htmlEditorOptions: HtmlEditorOptions(
                            initialText: entry.value.text,
                          ),
                          otherOptions: const OtherOptions(
                            height: 400,
                          ),
                          callbacks: Callbacks(
                            onChangeContent: (String? changed) {
                              entry.value.text = changed ?? '';
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class EditDialogWithCards extends StatelessWidget {
  final String title;
  final Map<String, String> fields;
  final List<CardModel> cards;
  final Function(Map<String, String>, List<CardModel>) onSave;

  const EditDialogWithCards({
    super.key,
    required this.title,
    required this.fields,
    required this.cards,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final controllers = fields.map(
      (key, value) => MapEntry(key, TextEditingController(text: value)),
    );

    bool isUploading = false;
    bool showImage = true;

    return Dialog(
      child: StatefulBuilder(
        builder: (context, setState) => Scaffold(
          appBar: AppBar(
            title: Text('Edit $title'),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  final values = controllers.map(
                    (key, controller) => MapEntry(key, controller.text),
                  );
                  onSave(values, cards);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ...controllers.entries.map((entry) {
                  if (entry.key == 'Title') {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        controller: entry.value,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: entry.key,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    );
                  } else if (entry.key == 'Image URL') {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Image',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  const Text('Show Image'),
                                  Switch(
                                    value: showImage,
                                    onChanged: (value) {
                                      setState(() {
                                        showImage = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: entry.value.text.isEmpty
                                    ? const Text(
                                        'No image uploaded',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : SelectableText(
                                        entry.value.text,
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isUploading = true;
                                  });
                                  final downloadUrl =
                                      await FirebaseStorageServices
                                          .pickAndUploadImage();
                                  entry.value.text = downloadUrl;
                                  setState(() {
                                    isUploading = false;
                                  });
                                },
                                child: isUploading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Upload Image'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.key,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          HtmlEditor(
                            controller: HtmlEditorController(),
                            htmlEditorOptions: HtmlEditorOptions(
                              initialText: entry.value.text,
                            ),
                            otherOptions: const OtherOptions(
                              height: 400,
                            ),
                            callbacks: Callbacks(
                              onChangeContent: (String? changed) {
                                entry.value.text = changed ?? '';
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
                const Divider(height: 24),
                CardsEditor(setState: setState, cards: cards),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditDialogWithStreams extends StatelessWidget {
  final String title;
  final Map<String, String> fields;
  final List<StreamCardModel> streams;
  final Function(Map<String, String>, List<StreamCardModel>) onSave;

  const EditDialogWithStreams({
    super.key,
    required this.title,
    required this.fields,
    required this.streams,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final controllers = fields.map(
      (key, value) => MapEntry(key, TextEditingController(text: value)),
    );

    bool isUploading = false;
    bool showImage = true;

    return Dialog(
      child: StatefulBuilder(
        builder: (context, setState) => Scaffold(
          appBar: AppBar(
            title: Text('Edit $title'),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  final values = controllers.map(
                    (key, controller) => MapEntry(key, controller.text),
                  );
                  onSave(values, streams);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ...controllers.entries.map((entry) {
                  if (entry.key == 'Title') {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        controller: entry.value,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: entry.key,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    );
                  } else if (entry.key == 'Image URL') {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Image',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  const Text('Show Image'),
                                  Switch(
                                    value: showImage,
                                    onChanged: (value) {
                                      setState(() {
                                        showImage = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: entry.value.text.isEmpty
                                    ? const Text(
                                        'No image uploaded',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : SelectableText(
                                        entry.value.text,
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isUploading = true;
                                  });
                                  final downloadUrl =
                                      await FirebaseStorageServices
                                          .pickAndUploadImage();
                                  entry.value.text = downloadUrl;
                                  setState(() {
                                    isUploading = false;
                                  });
                                },
                                child: isUploading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Upload Image'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.key,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          HtmlEditor(
                            controller: HtmlEditorController(),
                            htmlEditorOptions: HtmlEditorOptions(
                              initialText: entry.value.text,
                            ),
                            otherOptions: const OtherOptions(
                              height: 400,
                            ),
                            callbacks: Callbacks(
                              onChangeContent: (String? changed) {
                                entry.value.text = changed ?? '';
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
                const Divider(height: 24),
                StreamsEditor(setState: setState, streams: streams),
              ],
            ),
          ),
        ),
      ),
    );
  }
}