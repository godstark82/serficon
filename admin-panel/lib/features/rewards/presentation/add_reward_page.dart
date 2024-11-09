import 'dart:typed_data';
import 'package:conference_admin/core/datastate/data_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:conference_admin/core/models/card_model.dart';
import 'package:conference_admin/features/rewards/repositories/rewards_repo_impl.dart';
import 'package:conference_admin/core/services/firebase_storage_services.dart';

class AddRewardPage extends StatefulWidget {
  const AddRewardPage({super.key});

  @override
  State<AddRewardPage> createState() => _AddRewardPageState();
}

class _AddRewardPageState extends State<AddRewardPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rewardsRepo = RewardsRepoImpl();

  Uint8List? _imageBytes;
  String? _imageUrl;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final imageBytes = await ImagePickerWeb.getImageAsBytes();
    if (imageBytes != null) {
      setState(() {
        _imageBytes = imageBytes;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageBytes == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final url = await FirebaseStorageServices.uploadImage(
        _imageBytes!,
        'rewards/$fileName.jpg',
      );

      setState(() {
        _imageUrl = url;
        _isUploading = false;
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    }
  }

  Future<void> _saveReward() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final reward = CardModel(
      image: _imageUrl,
      title: _titleController.text,
      description: _descriptionController.text,
    );

    final result = await _rewardsRepo.addRewards(reward);

    if (result is DataSuccess) {
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error saving reward')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Reward'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reward Details',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),
                        if (_imageBytes != null) ...[
                          Image.memory(
                            _imageBytes!,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 16),
                        ],
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: _pickImage,
                              child: const Text('Select Image'),
                            ),
                            const SizedBox(width: 16),
                            if (_imageBytes != null && !_isUploading)
                              ElevatedButton(
                                onPressed: _uploadImage,
                                child: const Text('Upload Image'),
                              ),
                            if (_isUploading)
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: CircularProgressIndicator(),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _saveReward,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('Save Reward'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
