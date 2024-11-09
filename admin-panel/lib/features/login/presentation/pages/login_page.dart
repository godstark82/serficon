import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:conference_admin/features/login/data/repositories/login_repo_impl.dart';
import 'package:conference_admin/features/login/presentation/bloc/login_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'dart:ui';
import 'dart:math';
import 'package:conference_admin/core/services/mailer_service.dart';
import 'package:conference_admin/core/snack_bars.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _forgotEmailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _obscureText = true;
  String? _generatedOTP;

  Future<void> _showForgotPasswordDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Forgot Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _forgotEmailController,
              decoration: const InputDecoration(
                labelText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_forgotEmailController.text.isNotEmpty) {
                  Random random = Random();
                  _generatedOTP = (random.nextInt(900000) + 100000).toString();

                  await MailService().sendEmail(
                      _forgotEmailController.text,
                      'Password Reset OTP',
                      'Your OTP for password reset is: $_generatedOTP');

                  Navigator.pop(context);
                  _showOTPVerificationDialog();
                }
              },
              child: const Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showOTPVerificationDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verify OTP'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_otpController.text == _generatedOTP) {
                  // Here you would typically:
                  String password = '';
                  final userDoc = await FirebaseFirestore.instance
                      .collection('users')
                      .where('email', isEqualTo: _forgotEmailController.text)
                      .limit(1)
                      .get();

                  if (userDoc.docs.isNotEmpty) {
                    password = userDoc.docs.first.get('password');
                  } else {
                    Navigator.pop(context);
                    MySnacks.showErrorSnack('User Not Found');
                    return;
                  }
                  // 1. Get user's password from backend
                  // 2. Send it to their email
                  await MailService().sendEmail(
                      _forgotEmailController.text,
                      'Your Credentials for Abhi Journals',
                      'Your email is: [${_emailController.text}] \nYour password is: [$password]' // Replace with actual password
                      );

                  Navigator.pop(context);
                  MySnacks.showSuccessSnack('Password sent to your email');
                } else {
                  MySnacks.showErrorSnack('Invalid OTP');
                }
              },
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      context.read<LoginBloc>().add(LoginInitiateLoginEvent(EmailPassModel(
          email: _emailController.text, password: _passwordController.text)));
    } finally {}
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[100]!, Colors.purple[100]!],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  toolbarHeight: context.isPhone ? 100 : 150,
                  backgroundColor: Colors.transparent,
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Abhi International Journals',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Be a part of AIJ by Creating a suitable account',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                body: Stack(
                  children: [
                    // Login content
                    ResponsiveBuilder(
                      builder: (context, sizingInfo) {
                        return Center(
                          child: SingleChildScrollView(
                            child: Container(
                              width: sizingInfo.isMobile
                                  ? context.width * 0.9
                                  : 400,
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 5,
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sign in',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[800],
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      hintText: 'Email or phone',
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: _passwordController,
                                    obscureText: _obscureText,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: _showForgotPasswordDialog,
                                      child: const Text('Forgot Password?'),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: state is LoginLoadingState
                                          ? null
                                          : _handleSignIn,
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.blue[700],
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: state is LoginLoadingState
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text('Sign in',
                                              style: TextStyle(fontSize: 18)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
