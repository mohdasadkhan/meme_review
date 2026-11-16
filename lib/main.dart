import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meme_review/app/app.dart';
import 'package:meme_review/app/theme/app_colors.dart';
import 'package:meme_review/core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Android uses native google-services.json via the Google Services plugin.
  // Run FlutterFire CLI (`flutterfire configure`) to generate firebase_options.dart
  // for multi-platform DefaultFirebaseOptions support.
  await Firebase.initializeApp();

  await configureDependencies();

  runApp(const MemeArenaApp());
}
