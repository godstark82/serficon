import 'dart:typed_data';

import 'package:conference_admin/core/const/committee_role.dart';
import 'package:conference_admin/features/committee/data/models/committee_member_model.dart';
import 'package:conference_admin/features/committee/presentation/bloc/committee_bloc.dart';
import 'package:conference_admin/core/services/firebase_storage_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class UpdateMemberPage extends StatefulWidget {
  const UpdateMemberPage({super.key});

  @override
  _UpdateMemberPageState createState() => _UpdateMemberPageState();
}

class _UpdateMemberPageState extends State<UpdateMemberPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final memberId = Get.parameters['memberId']!;
  CommitteeRole? selectedRole;
  String? imageUrl;
  Uint8List? imageBytes;

  bool isUploading = false;
  String? imageError;
  String? currentImageUrl;

  @override
  void initState() {
    super.initState();
    context.read<CommitteeBloc>().add(GetCMemberByIdEvent(memberId));
  }

  bool get isFormValid =>
      nameController.text.isNotEmpty &&
      selectedRole != null &&
      (imageUrl != null || currentImageUrl != null) &&
      !isUploading;

  Future<void> _pickImage() async {
    setState(() {
      imageError = null;
      isUploading = true;
    });

    try {
      final String downloadUrl =
          await FirebaseStorageServices.pickAndUploadImage();
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
        title: const Text('Update Committee Member'),
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
      body: BlocConsumer<CommitteeBloc, CommitteeState>(
        listener: (context, state) {
          if (state is LoadedSingleCommitteeState) {
            final member = state.member;
            nameController.text = member.name;
            designationController.text = member.designation;
            positionController.text = member.position;
            selectedRole = member.role;
            currentImageUrl = member.image;
          }
        },
        builder: (context, state) {
          if (state is LoadingSingleCommitteeState) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                  image: (imageUrl != null)
                                      ? DecorationImage(
                                          image: NetworkImage(imageUrl!),
                                          fit: BoxFit.cover,
                                        )
                                      : (currentImageUrl != null)
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  currentImageUrl!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                ),
                                child: (imageUrl == null &&
                                        currentImageUrl == null)
                                    ? const Icon(Icons.add_a_photo, size: 50)
                                    : null,
                              ),
                              FloatingActionButton.small(
                                onPressed: _pickImage,
                                child: const Icon(Icons.edit),
                              ),
                            ],
                          ),
                          if (isUploading) ...[
                            const SizedBox(height: 8),
                            const CircularProgressIndicator(),
                          ],
                          if (imageUrl != null) ...[
                            const SizedBox(height: 8),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check, color: Colors.green),
                                SizedBox(width: 8),
                                Text('Image uploaded successfully',
                                    style: TextStyle(color: Colors.green)),
                              ],
                            ),
                          ],
                          if (imageError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                imageError!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: designationController,
                            decoration: const InputDecoration(
                              labelText: 'Designation',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: positionController,
                            decoration: const InputDecoration(
                              labelText: 'Position',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<CommitteeRole>(
                            value: selectedRole,
                            decoration: const InputDecoration(
                              labelText: 'Role',
                              border: OutlineInputBorder(),
                            ),
                            items: CommitteeRole.values.map((role) {
                              return DropdownMenuItem(
                                value: role,
                                child: Text(role.value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedRole = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: isFormValid
                        ? () {
                            final updatedMember = CommitteeMemberModel(
                              id: memberId,
                              name: nameController.text,
                              designation: designationController.text,
                              position: positionController.text,
                              role: selectedRole!,
                              image: imageUrl ?? currentImageUrl!,
                            );
                            context
                                .read<CommitteeBloc>()
                                .add(UpdateCommitteeMemberEvent(updatedMember));
                            Get.back();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Update Member'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    designationController.dispose();
    positionController.dispose();
    super.dispose();
  }
}
