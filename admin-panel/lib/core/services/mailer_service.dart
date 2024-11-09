
// ignore: depend_on_referenced_packages
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class MailService {
  static const String apiKey = String.fromEnvironment('MAILGUN_API_KEY');
  static const String domain = String.fromEnvironment('MAILGUN_DOMAIN');

  Future<void> sendEmail(
      String recipientEmail, String subject, String message) async {
    const String url = 'https://api.mailgun.net/v3/$domain/messages';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('api:$apiKey'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'from': 'Abhi International Journals <support@$domain>',
        'to': recipientEmail,
        'subject': subject,
        'text': message,
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Email sent successfully!');
      }
    } else {
      if (kDebugMode) {
        print('Failed to send email: ${response.body}');
      }
    }
  }
}
