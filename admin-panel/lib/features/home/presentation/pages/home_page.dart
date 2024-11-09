import 'package:conference_admin/core/models/card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import '../bloc/home_bloc.dart';
import '../../data/models/home_models_others.dart';
import 'package:conference_admin/core/services/firebase_storage_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(GetHomeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home Management'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Hero Section
                      _buildSection(
                        'Hero Section',
                        [
                          _buildInfoRow(
                              'Content', state.homeModel.hero.htmlContent),
                          _buildInfoRow('Image URL',
                              state.homeModel.hero.image ?? 'No image'),
                        ],
                        onEdit: () => _showEditDialog(
                          context,
                          'Hero Section',
                          {
                            'Content': state.homeModel.hero.htmlContent,
                            'Image URL': state.homeModel.hero.image ?? '',
                          },
                          (values) {
                            final hero = HomeHeroModel(
                              htmlContent: values['Content']!,
                              image: values['Image URL'],
                            );
                            context.read<HomeBloc>().add(UpdateHeroEvent(hero));
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // President Welcome
                      _buildSection(
                        'President Welcome',
                        [
                          _buildInfoRow(
                              'Title', state.homeModel.presidentWelcome.title),
                          _buildInfoRow('Content',
                              state.homeModel.presidentWelcome.htmlContent),
                          _buildInfoRow(
                              'Image URL',
                              state.homeModel.presidentWelcome.image ??
                                  'No image'),
                        ],
                        onEdit: () => _showEditDialog(
                          context,
                          'President Welcome',
                          {
                            'Title': state.homeModel.presidentWelcome.title,
                            'Content':
                                state.homeModel.presidentWelcome.htmlContent,
                            'Image URL':
                                state.homeModel.presidentWelcome.image ?? '',
                          },
                          (values) {
                            final welcome = HomePresidentWelcomeModel(
                              title: values['Title']!,
                              htmlContent: values['Content']!,
                              image: values['Image URL'],
                            );
                            context
                                .read<HomeBloc>()
                                .add(UpdateWelcomeEvent(welcome));
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Congress Scope
                      _buildSection(
                        'Congress Scope',
                        [
                          _buildInfoRow(
                              'Title', state.homeModel.congressScope.title),
                          _buildInfoRow('Description',
                              state.homeModel.congressScope.description),
                          const Divider(height: 24),
                          _buildCardsList('Scope Cards',
                              state.homeModel.congressScope.cards),
                        ],
                        onEdit: () => _showEditDialogWithCards(
                          context,
                          'Congress Scope',
                          {
                            'Title': state.homeModel.congressScope.title,
                            'Description':
                                state.homeModel.congressScope.description,
                          },
                          state.homeModel.congressScope.cards,
                          (values, cards) {
                            final scope = HomeCongressScopeModel(
                              title: values['Title']!,
                              description: values['Description']!,
                              cards: cards,
                            );
                            context
                                .read<HomeBloc>()
                                .add(UpdateScopeEvent(scope));
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Congress Streams
                      _buildSection(
                        'Congress Streams',
                        [
                          _buildInfoRow(
                              'Title', state.homeModel.congressStream.title),
                          _buildInfoRow('Description',
                              state.homeModel.congressStream.description),
                          const Divider(height: 24),
                          _buildStreamsList(
                              'Streams', state.homeModel.congressStream.cards),
                        ],
                        onEdit: () => _showEditDialogWithStreams(
                          context,
                          'Congress Streams',
                          {
                            'Title': state.homeModel.congressStream.title,
                            'Description':
                                state.homeModel.congressStream.description,
                          },
                          state.homeModel.congressStream.cards,
                          (values, streams) {
                            final stream = HomeCongressStreamModel(
                              title: values['Title']!,
                              description: values['Description']!,
                              cards: streams,
                            );
                            context
                                .read<HomeBloc>()
                                .add(UpdateStreamEvent(stream));
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Publications
                      _buildSection(
                        'Publications',
                        [
                          _buildInfoRow('Content',
                              state.homeModel.publication.htmlContent),
                          _buildInfoRow('Image URL',
                              state.homeModel.publication.image ?? 'No image'),
                        ],
                        onEdit: () => _showEditDialog(
                          context,
                          'Publications',
                          {
                            'Content': state.homeModel.publication.htmlContent,
                            'Image URL':
                                state.homeModel.publication.image ?? '',
                          },
                          (values) {
                            final publication = HomePublicationModel(
                              htmlContent: values['Content']!,
                              image: values['Image URL'],
                            );
                            context
                                .read<HomeBloc>()
                                .add(UpdatePublicationEvent(publication));
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Why Choose Us
                      _buildSection(
                        'Why Choose Us',
                        [
                          _buildInfoRow(
                              'Title', state.homeModel.whyChooseUs.title),
                          _buildInfoRow('Description',
                              state.homeModel.whyChooseUs.description),
                          const Divider(height: 24),
                          _buildCardsList(
                              'Reasons', state.homeModel.whyChooseUs.cards),
                        ],
                        onEdit: () => _showEditDialogWithCards(
                          context,
                          'Why Choose Us',
                          {
                            'Title': state.homeModel.whyChooseUs.title,
                            'Description':
                                state.homeModel.whyChooseUs.description,
                          },
                          state.homeModel.whyChooseUs.cards,
                          (values, cards) {
                            final whyChooseUs = HomeWhyChooseUsModel(
                              title: values['Title']!,
                              description: values['Description']!,
                              cards: cards,
                            );
                            context
                                .read<HomeBloc>()
                                .add(UpdateWcuEvent(whyChooseUs));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    String title,
    Map<String, String> fields,
    Function(Map<String, String>) onSave,
  ) async {
    final controllers = fields.map(
      (key, value) => MapEntry(key, TextEditingController(text: value)),
    );

    bool isUploading = false;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Edit $title'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    final values = controllers.map(
                      (key, controller) => MapEntry(key, controller.text),
                    );
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
                  if (entry.key == 'Image URL') {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.key,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: entry.value,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
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
                  } else if (entry.key == 'Content') {
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        controller: entry.value,
                        decoration: InputDecoration(
                          labelText: entry.key,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    );
                  }
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );

    for (final controller in controllers.values) {
      controller.dispose();
    }
  }

  Future<void> _showEditDialogWithCards(
    BuildContext context,
    String title,
    Map<String, String> fields,
    List<CardModel> cards,
    Function(Map<String, String>, List<CardModel>) onSave,
  ) async {
    final controllers = fields.map(
      (key, value) => MapEntry(key, TextEditingController(text: value)),
    );

    bool isUploading = false;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          child: Scaffold(
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
                    if (entry.key == 'Image URL') {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.key,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: entry.value,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
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
                    } else if (entry.key == 'Content') {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.key,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: entry.value,
                          decoration: InputDecoration(
                            labelText: entry.key,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      );
                    }
                  }),
                  const Divider(height: 24),
                  _buildCardsEditor(cards, setState),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    for (final controller in controllers.values) {
      controller.dispose();
    }
  }

  Future<void> _showEditDialogWithStreams(
    BuildContext context,
    String title,
    Map<String, String> fields,
    List<StreamCardModel> streams,
    Function(Map<String, String>, List<StreamCardModel>) onSave,
  ) async {
    final controllers = fields.map(
      (key, value) => MapEntry(key, TextEditingController(text: value)),
    );

    bool isUploading = false;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          child: Scaffold(
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
                    if (entry.key == 'Image URL') {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.key,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: entry.value,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
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
                    } else if (entry.key == 'Content') {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.key,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          controller: entry.value,
                          decoration: InputDecoration(
                            labelText: entry.key,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      );
                    }
                  }),
                  const Divider(height: 24),
                  _buildStreamsEditor(streams, setState),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    for (final controller in controllers.values) {
      controller.dispose();
    }
  }

  Widget _buildSection(String title, List<Widget> children,
      {VoidCallback? onEdit}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                if (onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: onEdit,
                    color: Colors.blue,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCardsList(String title, List<dynamic> cards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return ListTile(
              leading: const Icon(Icons.article),
              title: Text(card.title),
              subtitle: Text(card.description),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStreamsList(String title, List<dynamic> streams) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: streams.length,
          itemBuilder: (context, index) {
            final stream = streams[index];
            return ExpansionTile(
              title: Text(stream.title),
              children: stream.descriptions.map<Widget>((desc) {
                return ListTile(
                  leading: const Icon(Icons.arrow_right),
                  title: Text(desc),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCardsEditor(List<CardModel> cards, StateSetter setState) {
    bool isUploading = false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cards',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            CardModel card = cards[index];
            return ListTile(
              leading: const Icon(Icons.article),
              title: TextField(
                controller: TextEditingController(text: card.title),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    card = card.copyWith(title: value);
                  });
                },
              ),
              subtitle: Column(
                children: [
                  TextField(
                    controller: TextEditingController(text: card.description),
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        card = card.copyWith(description: value);
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(text: card.image),
                          decoration: const InputDecoration(
                            labelText: 'Image URL',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              card = card.copyWith(image: value);
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isUploading = true;
                          });
                          final downloadUrl = await FirebaseStorageServices
                              .pickAndUploadImage();
                          setState(() {
                            card = card.copyWith(image: downloadUrl);
                          });
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
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    cards.removeAt(index);
                  });
                },
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            setState(() {
              cards.add(
                  CardModel(title: 'New Card', description: '', image: ''));
            });
          },
          child: const Text('Add Card'),
        ),
      ],
    );
  }

  Widget _buildStreamsEditor(
      List<StreamCardModel> streams, StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Streams',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: streams.length,
          itemBuilder: (context, index) {
            StreamCardModel stream = streams[index];
            return ListTile(
              leading: const Icon(Icons.article),
              title: TextField(
                controller: TextEditingController(text: stream.title),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    stream = stream.copyWith(title: value);
                  });
                },
              ),
              subtitle: Column(
                children: [
                  ...stream.descriptions.map((desc) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: TextField(
                        controller: TextEditingController(text: desc),
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            final index = stream.descriptions.indexOf(desc);
                            stream = stream.copyWith(descriptions: [
                              ...stream.descriptions.sublist(0, index),
                              value,
                              ...stream.descriptions.sublist(index + 1)
                            ]);
                          });
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        stream.descriptions.add('');
                      });
                    },
                    child: const Text('Add Description'),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    streams.removeAt(index);
                  });
                },
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            setState(() {
              streams
                  .add(StreamCardModel(title: 'New Stream', descriptions: []));
            });
          },
          child: const Text('Add Stream'),
        ),
      ],
    );
  }
}
