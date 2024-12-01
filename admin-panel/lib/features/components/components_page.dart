import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conference_admin/core/services/firebase_storage_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ComponentsPage extends StatefulWidget {
  const ComponentsPage({super.key});

  @override
  State<ComponentsPage> createState() => _ComponentsPageState();
}

class _ComponentsPageState extends State<ComponentsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool _isUploading = false;
  final double _uploadProgress = 0.0;
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      'facebook': TextEditingController(),
      'instagram': TextEditingController(),
      'linkedin': TextEditingController(),
      'twitter': TextEditingController(),
      'youtube': TextEditingController(),
      'phone': TextEditingController(),
      'email': TextEditingController(),
      'address': TextEditingController(),
      'navtitle': TextEditingController(),
      'title': TextEditingController(),
      'logo': TextEditingController(),
      'domain': TextEditingController(),
    };
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<Map<String, dynamic>> _loadComponentData() async {
    try {
      final docSnapshot =
          await _firestore.collection('components').doc('settings').get();
      if (docSnapshot.exists) {
        return docSnapshot.data() ?? {};
      }
      return {};
    } catch (e) {
      if (kDebugMode) {
        print('Error loading component data: $e');
      }
      return {};
    }
  }

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      try {
        Map<String, dynamic> updatedData = {};
        _controllers.forEach((key, controller) {
          updatedData[key] = controller.text;
        });

        await _firestore.collection('components').doc('settings').set(
              updatedData,
              SetOptions(merge: true),
            );

        setState(() {
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e')),
        );
      }
    }
  }

  Future<void> _uploadSvg() async {
    try {
      setState(() {
        _isUploading = true;
      });
      
      if (kDebugMode) {
        print('Uploading SVG');
      }
      String url = await FirebaseStorageServices.pickAndUploadSvg();
      if (kDebugMode) {
        print('SVG uploaded: $url');
      }
      
      setState(() {
        _controllers['logo']!.text = url;
        _isUploading = false;
      });

      // Save the updated logo URL to Firestore
      await _firestore.collection('components').doc('settings').set(
        {'logo': url},
        SetOptions(merge: true),
      );

    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading SVG: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Components Settings'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveData();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadComponentData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data ?? {};

          if (!_isEditing) {
            _controllers.forEach((key, controller) {
              controller.text = data[key] ?? '';
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Logo (SVG)',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_controllers['logo']!.text.isNotEmpty)
                            SvgPicture.network(
                              _controllers['logo']!.text,
                              height: 100,
                            ),
                          const SizedBox(height: 8),
                          if (_isEditing) ...[
                            ElevatedButton(
                              onPressed: _isUploading ? null : _uploadSvg,
                              child: Text(_isUploading
                                  ? 'Uploading...'
                                  : 'Upload SVG Logo'),
                            ),
                            if (_isUploading) ...[
                              const SizedBox(height: 8),
                              LinearProgressIndicator(value: _uploadProgress),
                              Text(
                                  '${(_uploadProgress * 100).toStringAsFixed(1)}%'),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Social Media Links',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildEditableField(
                              'Facebook', _controllers['facebook']!),
                          _buildEditableField(
                              'Instagram', _controllers['instagram']!),
                          _buildEditableField(
                              'LinkedIn', _controllers['linkedin']!),
                          _buildEditableField(
                              'Twitter', _controllers['twitter']!),
                          _buildEditableField(
                              'YouTube', _controllers['youtube']!),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Contact Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildEditableField('Phone', _controllers['phone']!),
                          _buildEditableField('Email', _controllers['email']!),
                          _buildEditableField(
                              'Address', _controllers['address']!),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Website Settings',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildEditableField(
                              'Navigation Title', _controllers['navtitle']!),
                          _buildEditableField('Title', _controllers['title']!),
                          _buildEditableField('Domain', _controllers['domain']!),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _isEditing
                ? TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }
                      return null;
                    },
                  )
                : Text(controller.text.isEmpty ? 'Not set' : controller.text),
          ),
        ],
      ),
    );
  }
}
