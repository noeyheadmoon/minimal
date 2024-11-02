// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter/material.dart';
import 'package:minimals/screen/home.dart';
import 'package:minimals/screen/info.dart';
import 'package:minimals/screen/login.dart';
import 'package:minimals/screen/splash.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Kakao SDK 초기화
  KakaoSdk.init(
    nativeAppKey: 'e92d8115f094b5bcb6e65e07fadfbe8a',
    javaScriptAppKey: '5fec4ca4bba84279a5aecb0dc36e3341',
  );

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimals App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const HomeScreen(),
        '/info': (context) => const InfoScreen(),
      },
    );
  }
}
