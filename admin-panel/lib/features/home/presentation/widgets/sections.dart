import 'package:conference_admin/core/models/card_model.dart';
import 'package:conference_admin/core/services/firebase_storage_services.dart';
import 'package:conference_admin/features/home/data/models/home_models_others.dart';
import 'package:flutter/material.dart';

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
              title: Text(card.title),
              subtitle: Text(card.description),
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
            return ExpansionTile(
              title: Text(stream.title),
              children: stream.descriptions.map((desc) {
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
                maxLines: null,
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
                    maxLines: null,
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
                          maxLines: null,
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
                maxLines: null,
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
                        maxLines: null,
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
