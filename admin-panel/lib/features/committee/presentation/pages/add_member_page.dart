import 'package:conference_admin/core/const/committee_role.dart';
import 'package:conference_admin/features/committee/data/models/committee_member_model.dart';
import 'package:conference_admin/features/committee/presentation/bloc/committee_bloc.dart';
import 'package:conference_admin/core/services/firebase_storage_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({super.key});

  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController(text: '1');
  CommitteeRole? selectedRole;
  Uint8List? imageBytes;
  String? imageUrl;
  bool isUploading = false;
  String? imageError;

  bool get isFormValid => 
    nameController.text.isNotEmpty && 
    selectedRole != null && 
    imageUrl != null &&
    !isUploading;

  Future<void> _pickImage() async {
    setState(() {
      imageError = null;
      isUploading = true;
    });
    
    try {
      final String downloadUrl = await FirebaseStorageServices.pickAndUploadImage();
      setState(() {
        imageUrl = downloadUrl;
        imageError = null;
        isUploading = false;
      });
    } catch (e) {
      setState(() {
        imageError = 'Failed to pick/upload image: $e';
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Committee Member'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.7),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[100]!,
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<CommitteeRole>(
                    value: selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: CommitteeRole.values.map((CommitteeRole role) {
                      return DropdownMenuItem<CommitteeRole>(
                        value: role,
                        child: Text(role.value),
                      );
                    }).toList(),
                    onChanged: (CommitteeRole? newValue) {
                      setState(() {
                        selectedRole = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: positionController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Position',
                            border: const OutlineInputBorder(),
                            helperText: 'Lower number appears first on page',
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    final currentValue = int.tryParse(positionController.text) ?? 1;
                                    positionController.text = (currentValue - 1).toString();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    final currentValue = int.tryParse(positionController.text) ?? 1;
                                    positionController.text = (currentValue + 1).toString();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (imageUrl != null) ...[
                    const SizedBox(height: 16),
                    Image.network(
                      imageUrl!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    onPressed: isUploading ? null : _pickImage,
                    icon: isUploading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2)
                        )
                      : const Icon(Icons.upload_file),
                    label: Text(isUploading ? 'Uploading...' : 'Upload Image'),
                  ),
                  if (imageUrl != null) ...[
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Image uploaded successfully', style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ],
                  if (imageError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      imageError!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                      backgroundColor: Theme.of(context).primaryColor,
                      disabledBackgroundColor: Colors.grey,
                    ),
                    onPressed: isFormValid 
                      ? () {
                          final String name = nameController.text;
                          final String position = positionController.text;

                          final newMember = CommitteeMemberModel(
                              id: '1',
                              position: position,
                              designation: '',
                              image: imageUrl!,
                              name: name,
                              role: selectedRole!);
                          context
                              .read<CommitteeBloc>()
                              .add(AddCommitteeMemberEvent(newMember));
                          Navigator.of(context).pop();
                        }
                      : null,
                    child: const Text('Add Member', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
