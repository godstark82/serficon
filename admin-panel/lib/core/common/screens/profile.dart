import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conference_admin/core/const/login_const.dart';
import 'package:conference_admin/features/login/presentation/bloc/login_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:conference_admin/core/services/mailer_service.dart';
import 'package:conference_admin/core/snack_bars.dart';
import 'dart:math';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _generatedOTP;

  Future<void> _showChangePasswordDialog() async {
    Random random = Random();
    _generatedOTP = (random.nextInt(900000) + 100000).toString();

    await MailService().sendEmail(
        LoginConst.currentUser?.email ?? '',
        'Password Change OTP',
        'Your OTP for password change is: $_generatedOTP');

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Please enter the OTP sent to ${LoginConst.currentUser?.email}'),
              const SizedBox(height: 16),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Enter OTP',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _otpController.clear();
                _newPasswordController.clear();
                _confirmPasswordController.clear();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_otpController.text != _generatedOTP) {
                  MySnacks.showErrorSnack('Invalid OTP. Please try again.');
                  return;
                }
                if (_newPasswordController.text !=
                    _confirmPasswordController.text) {
                  MySnacks.showErrorSnack('Passwords do not match');
                  return;
                }
                if (_newPasswordController.text.length < 6) {
                  MySnacks.showErrorSnack(
                      'Password must be at least 6 characters');
                  return;
                }

                context.read<LoginBloc>().add(ChangePasswordEvent(
                    email: LoginConst.currentUser?.email ?? '',
                    newPassword: _newPasswordController.text));
                Navigator.pop(context);
                _otpController.clear();
                _newPasswordController.clear();
                _confirmPasswordController.clear();
              },
              child: const Text('Change Password'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[400]!, Colors.purple[300]!],
          ),
        ),
        child: SafeArea(
          child: ResponsiveBuilder(
            builder: (context, sizingInformation) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'My Profile',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          onPressed: () {
                            context.read<LoginBloc>().add(LogoutEvent());
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Container(
                          width: sizingInformation.deviceScreenType ==
                                  DeviceScreenType.desktop
                              ? 600
                              : sizingInformation.screenSize.width * 0.9,
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.blue[100],
                                child: Icon(Icons.person,
                                    size: 60, color: Colors.blue[800]),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                LoginConst.currentUser?.name ?? 'User',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                LoginConst.currentUser?.email ??
                                    'email@example.com',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Role: ADMIN',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.blue[800]),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: _showChangePasswordDialog,
                                icon: const Icon(Icons.lock),
                                label: const Text('Change Password'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
