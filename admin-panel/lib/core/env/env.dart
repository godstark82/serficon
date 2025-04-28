// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env.icostem')
abstract class Env {
  @EnviedField(varName: 'FIREBASE_OPTIONS_API_KEY')
  static const String apiKey = _Env.apiKey;
  @EnviedField(varName: 'FIREBASE_OPTIONS_APP_ID')
  static const String appId = _Env.appId;
  @EnviedField(varName: 'FIREBASE_OPTIONS_MESSAGING_SENDER_ID')
  static const String messagingSenderId = _Env.messagingSenderId;
  @EnviedField(varName: 'FIREBASE_OPTIONS_PROJECT_ID')
  static const String projectId = _Env.projectId;
  @EnviedField(varName: 'FIREBASE_OPTIONS_AUTH_DOMAIN')
  static const String authDomain = _Env.authDomain;
  @EnviedField(varName: 'FIREBASE_OPTIONS_STORAGE_BUCKET')
  static const String storageBucket = _Env.storageBucket;
  @EnviedField(varName: 'FIREBASE_OPTIONS_MEASUREMENT_ID')
  static const String measurementId = _Env.measurementId;
}
