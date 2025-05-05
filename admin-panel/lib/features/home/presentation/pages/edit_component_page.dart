import 'package:conference_admin/core/const/toolbars.dart';
import 'package:conference_admin/core/models/card_model.dart';
import 'package:conference_admin/core/models/stream_card_model.dart';
import 'package:conference_admin/core/services/firebase_storage_services.dart';
import 'package:conference_admin/features/home/data/models/home_component_model.dart';
import 'package:conference_admin/features/home/domain/entities/home_component_entity.dart';
import 'package:conference_admin/features/home/presentation/bloc/home_bloc.dart';
import 'package:conference_admin/features/home/presentation/widgets/sections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditComponentPage extends StatefulWidget {
  const EditComponentPage({super.key});

  @override
  State<EditComponentPage> createState() => _EditComponentPageState();
}

class _EditComponentPageState extends State<EditComponentPage> {
  final String componentId = Get.parameters['id'] ?? '';
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _htmlSourceController;
  final HtmlEditorController _htmlController =
      HtmlEditorController(processNewLineAsBr: true);
  HomeComponentModel? _component;
  bool _isHtmlLoaded = false;
  bool _isEditorReady = false;
  int _selectedOrder = 0;
  Color? _selectedColor;
  bool _showHtmlSource = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _htmlSourceController = TextEditingController();
    context.read<HomeBloc>().add(GetHomeComponentEvent());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _htmlSourceController.dispose();
    super.dispose();
  }

  void _loadHtmlContent() {
    if (!_isHtmlLoaded && _component != null && _isEditorReady) {
      _titleController.text = _component!.title;
      _descriptionController.text = _component!.description ?? '';
      if (_component!.htmlContent != null) {
        _htmlController.setText(_component!.htmlContent!);
        _htmlSourceController.text = _component!.htmlContent!;
      }
      _selectedOrder = _component!.order;
      setState(() {
        _selectedColor = _component!.bgColor;
      });
      _isHtmlLoaded = true;
    }
  }

  void _updateComponent() async {
    if (_formKey.currentState!.validate() && _component != null) {
      String htmlContent;

      if (_showHtmlSource) {
        htmlContent = _htmlSourceController.text;
      } else {
        htmlContent = await _htmlController.getText();
      }

      // Ensure color values are converted to integers
      final safeColor = Color(
        _selectedColor?.value ?? 0xFFFFFFFF,
      );

      final updatedComponent = _component!.copyWith(
          title: _titleController.text,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
          bgColor: safeColor,
          htmlContent: htmlContent.isEmpty ? null : htmlContent,
          order: _selectedOrder);

      context.read<HomeBloc>().add(UpdateComponentEvent(updatedComponent));
      Navigator.pop(context);
    }
  }

  void _showYoutubeDialog() {
    final TextEditingController iframeController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Youtube Video'),
          content: TextField(
            controller: iframeController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Paste iframe code here',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (iframeController.text.isNotEmpty) {
                  if (_showHtmlSource) {
                    _htmlSourceController.text += iframeController.text;
                  } else {
                    _htmlController.insertHtml(iframeController.text);
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editCard(CardModel card, int index) {
    final TextEditingController titleController =
        TextEditingController(text: card.title ?? '');
    final TextEditingController descController =
        TextEditingController(text: card.description ?? '');
    final TextEditingController imageController =
        TextEditingController(text: card.image ?? '');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Edit Card'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: imageController,
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                        border: OutlineInputBorder(),
                      ),
                      enabled: false,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final imageUrl =
                            await FirebaseStorageServices.pickAndUploadImage();

                        imageController.text = imageUrl;
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to upload image: $e')),
                        );
                      }
                    },
                    child: const Text('Upload Image'),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_component?.cards != null) {
                setState(() {
                  _component!.cards![index] = CardModel(
                    title: titleController.text.isEmpty
                        ? null
                        : titleController.text,
                    description: descController.text.isEmpty
                        ? null
                        : descController.text,
                    image: imageController.text.isEmpty
                        ? null
                        : imageController.text,
                  );
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editStream(StreamCardModel stream, int index) {
    final titleController = TextEditingController(text: stream.title ?? '');
    final descriptionsController =
        TextEditingController(text: stream.descriptions?.join('\n') ?? '');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Edit Stream'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionsController,
                decoration: const InputDecoration(
                  labelText: 'Descriptions (one per line)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_component?.streamCards != null) {
                setState(() {
                  _component!.streamCards![index] = StreamCardModel(
                    title: titleController.text.isEmpty
                        ? null
                        : titleController.text,
                    descriptions: descriptionsController.text.isEmpty
                        ? null
                        : descriptionsController.text
                            .split('\n')
                            .where((line) => line.trim().isNotEmpty)
                            .toList(),
                  );
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _addCard() {
    setState(() {
      _component = _component?.copyWith(cards: _component?.cards ?? []);
      _component?.cards?.add(CardModel(
        title: 'New Card',
        description: 'Description',
        image: null,
      ));
    });
  }

  void _addStream() {
    setState(() {
      _component =
          _component?.copyWith(streamCards: _component?.streamCards ?? []);
      _component?.streamCards?.add(StreamCardModel(
        title: 'New Stream',
        descriptions: ['Description'],
      ));
    });
  }

  void _removeCard(int index) {
    setState(() {
      _component?.cards?.removeAt(index);
    });
  }

  void _removeStream(int index) {
    setState(() {
      _component?.streamCards?.removeAt(index);
    });
  }

  void _syncHtmlContent() async {
    if (_showHtmlSource) {
      // Update visual editor from source
      _htmlController.setText(_htmlSourceController.text);
    } else {
      // Update source from visual editor
      final html = await _htmlController.getText();
      _htmlSourceController.text = html;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Component'),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_library),
            onPressed: _showYoutubeDialog,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: _updateComponent,
              child: const Text('Update'),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeComponentsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeComponentLoaded) {
            _component = state.componentModel
                .firstWhereOrNull((comp) => comp.id == componentId);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Background Color:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              useRootNavigator: true,
                              builder: (context) => AlertDialog(
                                title: const Text('Pick a color'),
                                content: Builder(builder: (context) {
                                  // Use a Builder to get the correct context for getting screen size
                                  return Focus(
                                    child: SingleChildScrollView(
                                      child: ColorPicker(
                                        pickerColor:
                                            _selectedColor ?? Colors.white,
                                        onColorChanged: (Color color) {
                                          setState(
                                              () => _selectedColor = color);
                                        },
                                        enableAlpha: true,
                                        displayThumbColor: true,
                                        paletteType: PaletteType.hsv,
                                      ),
                                    ),
                                  );
                                }),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Done'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _selectedColor,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedColor = Colors.transparent;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[100],
                            foregroundColor: Colors.red[900],
                          ),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Order:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 16),
                        DropdownButton<int>(
                          value: _selectedOrder,
                          items: List.generate(state.componentModel.length,
                              (index) {
                            return DropdownMenuItem(
                              value: index,
                              child: Text(index.toString()),
                            );
                          }),
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedOrder = newValue;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Component Type: ${_component?.type.value ?? ""}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('HTML Content:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            const Text('Edit Source:'),
                            Switch(
                              value: _showHtmlSource,
                              onChanged: (value) {
                                _syncHtmlContent();
                                setState(() {
                                  _showHtmlSource = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_showHtmlSource)
                      SizedBox(
                        height: 400,
                        child: TextFormField(
                          controller: _htmlSourceController,
                          maxLines: null,
                          expands: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: 'Enter HTML source code here...',
                          ),
                          style: const TextStyle(
                            fontFamily: 'monospace',
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 400,
                        child: HtmlEditor(
                          htmlToolbarOptions: const HtmlToolbarOptions(
                              toolbarPosition: ToolbarPosition.belowEditor,
                              allowImagePicking: true,
                              defaultToolbarButtons: customToolbarOptions),
                          otherOptions: OtherOptions(
                              decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          )),
                          callbacks: Callbacks(
                            onInit: () {
                              _isEditorReady = true;
                              if (_component != null) {
                                _loadHtmlContent();
                              }
                            },
                          ),
                          controller: _htmlController,
                          htmlEditorOptions: HtmlEditorOptions(
                            hint: 'Enter your content here...',
                            shouldEnsureVisible: true,
                            darkMode: _selectedColor == Colors.transparent,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    if (_component?.type == HomeComponentType.withCards)
                      SectionWidget(
                        title: 'Cards',
                        children: [
                          ..._component?.cards?.asMap().entries.map((entry) {
                                final index = entry.key;
                                final card = entry.value;
                                return Card(
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
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () =>
                                                _editCard(card, index)),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () => _removeCard(index),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }) ??
                              [],
                          ElevatedButton.icon(
                            onPressed: _addCard,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Card'),
                          ),
                        ],
                      ),
                    if (_component?.type == HomeComponentType.withStream)
                      SectionWidget(
                        title: 'Stream Cards',
                        children: [
                          ..._component?.streamCards
                                  ?.asMap()
                                  .entries
                                  .map((entry) {
                                final index = entry.key;
                                final stream = entry.value;
                                return Card(
                                  child: ListTile(
                                    title: Text(stream.title ?? ''),
                                    subtitle: Text(
                                        stream.descriptions?.join(', ') ?? ''),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () =>
                                              _editStream(stream, index),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () => _removeStream(index),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }) ??
                              [],
                          ElevatedButton.icon(
                            onPressed: _addStream,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Stream Card'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          }

          if (state is HomeComponentError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
