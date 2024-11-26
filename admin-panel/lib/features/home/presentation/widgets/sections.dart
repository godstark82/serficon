import 'package:conference_admin/core/models/card_model.dart';
import 'package:conference_admin/core/models/stream_card_model.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class SectionWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback? onEdit;

  const SectionWidget({
    super.key,
    required this.title,
    required this.children,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
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
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
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
}

class CardsList extends StatelessWidget {
  final String title;
  final List<CardModel> cards;

  const CardsList({
    super.key,
    required this.title,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
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
              title: Text(card.title ?? 'No Title'),
              subtitle: Text(card.description ?? 'No Description'),
            );
          },
        ),
      ],
    );
  }
}

class StreamsList extends StatelessWidget {
  final String title;
  final List<StreamCardModel> streams;

  const StreamsList({
    super.key,
    required this.title,
    required this.streams,
  });

  @override
  Widget build(BuildContext context) {
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
            if (stream.descriptions == null) {
              return const SizedBox.shrink();
            }
            return ExpansionTile(
              title: Text(stream.title ?? 'No Title'),
              children: stream.descriptions!.map((desc) {
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
}

class CardsEditor extends StatelessWidget {
  final List<CardModel> cards;
  final StateSetter setState;

  const CardsEditor({
    super.key,
    required this.cards,
    required this.setState,
  });

  @override
  Widget build(BuildContext context) {
    final htmlController = HtmlEditorController();
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
              title: TextFormField(
                initialValue: card.title,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    card.title = value;
                  });
                },
              ),
              subtitle: Column(
                children: [
                  TextFormField(
                    initialValue: card.description,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        card.description = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: card.image,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Image',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        card.image = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      // Save the current card
                      await htmlController.getText().then((v) {
                        card.image = v;
                        setState(() {
                          cards[index] = card;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Card saved successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      });
                    },
                    child: const Text('Save Card'),
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
              cards.add(CardModel(title: '', description: '', image: ''));
            });
          },
          child: const Text('Add Card'),
        ),
      ],
    );
  }
}

class StreamsEditor extends StatelessWidget {
  final List<StreamCardModel> streams;
  final StateSetter setState;

  const StreamsEditor({
    super.key,
    required this.streams,
    required this.setState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Streams',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: streams.length,
          itemBuilder: (context, index) {
            final stream = streams[index];
            return ListTile(
              leading: const Icon(Icons.article),
              title: TextFormField(
                initialValue: stream.title,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    streams[index] = stream.copyWith(title: value);
                  });
                },
              ),
              subtitle: stream.descriptions == null
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        ...List.generate(stream.descriptions!.length,
                            (descIndex) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TextFormField(
                              initialValue: stream.descriptions![descIndex],
                              maxLines: null,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  final newDescriptions =
                                      List<String>.from(stream.descriptions!);
                                  newDescriptions[descIndex] = value;
                                  streams[index] = stream.copyWith(
                                      descriptions: newDescriptions);
                                });
                              },
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              final newDescriptions =
                                  List<String>.from(stream.descriptions!);
                              newDescriptions.add('');
                              streams[index] = stream.copyWith(
                                  descriptions: newDescriptions);
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
