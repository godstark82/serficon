import 'package:conference_admin/core/const/toolbars.dart';
import 'package:conference_admin/core/models/card_model.dart';
import 'package:conference_admin/core/models/stream_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../domain/entities/home_component_entity.dart';
import '../../data/models/home_component_model.dart';
import '../bloc/home_bloc.dart';
import '../widgets/sections.dart';

class AddComponentPage extends StatefulWidget {
  const AddComponentPage({super.key});

  @override
  State<AddComponentPage> createState() => _AddComponentPageState();
}

class _AddComponentPageState extends State<AddComponentPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _htmlController = HtmlEditorController(processNewLineAsBr: true);
  HomeComponentType _selectedType = HomeComponentType.withCards;
  String? _htmlContent;
  List<CardModel> cards = [];
  List<StreamCardModel> streams = [];
  int _selectedOrder = 0;
  Color _selectedColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetHomeComponentEvent());
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
                  _htmlController.insertHtml(iframeController.text);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Component'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveComponent,
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          int totalComponents = 0;
          if (state is HomeComponentLoaded) {
            totalComponents = state.componentModel.length;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Component Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Background Color:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Pick a color'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: _selectedColor,
                                  onColorChanged: (Color color) {
                                    setState(() => _selectedColor = color);
                                  },
                                  enableAlpha: false,
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Done'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
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
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Component Type:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 16),
                    SegmentedButton<HomeComponentType>(
                      segments: const [
                        ButtonSegment<HomeComponentType>(
                          value: HomeComponentType.withCards,
                          label: Text('With Cards'),
                        ),
                        ButtonSegment<HomeComponentType>(
                          value: HomeComponentType.withStream,
                          label: Text('With Stream'),
                        ),
                      ],
                      selected: {_selectedType},
                      onSelectionChanged:
                          (Set<HomeComponentType> newSelection) {
                        setState(() {
                          _selectedType = newSelection.first;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Order:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 16),
                    DropdownButton<int>(
                      value: _selectedOrder,
                      items: List.generate(totalComponents + 1, (index) {
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('HTML Content:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    ElevatedButton.icon(
                      onPressed: _showYoutubeDialog,
                      icon: const Icon(Icons.video_library),
                      label: const Text('Embed Youtube'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                  child: HtmlEditor(
                    controller: _htmlController,
                    htmlToolbarOptions: const HtmlToolbarOptions(
                        toolbarPosition: ToolbarPosition.belowEditor,
                        allowImagePicking: true,
                        defaultToolbarButtons: customToolbarOptions),
                    htmlEditorOptions: const HtmlEditorOptions(
                      hint: 'Enter your content here...',
                      shouldEnsureVisible: true,
                      autoAdjustHeight: true,
                    ),
                    otherOptions: const OtherOptions(
                      height: 400,
                    ),
                    callbacks: Callbacks(
                      onChangeContent: (String? changed) {
                        _htmlContent = changed;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_selectedType == HomeComponentType.withCards) ...[
                  const Text('Cards:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  CardsEditor(
                    setState: setState,
                    cards: cards,
                  ),
                ],
                if (_selectedType == HomeComponentType.withStream) ...[
                  const Text('Streams:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  StreamsEditor(
                    setState: setState,
                    streams: streams,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveComponent() {
    if (_titleController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Ensure color values are converted to integers
    final safeColor = Color(
      _selectedColor.value & 0xFFFFFFFF,
    );

    // Validate cards or streams based on selected type

    final component = HomeComponentModel(
      order: _selectedOrder,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      bgColor: safeColor,
      htmlContent: _htmlContent,
      display: true,
      type: _selectedType,
      cards: _selectedType == HomeComponentType.withCards ? cards : null,
      streamCards:
          _selectedType == HomeComponentType.withStream ? streams : null,
    );

    context.read<HomeBloc>().add(CreateComponentEvent(component));
    Get.back();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
