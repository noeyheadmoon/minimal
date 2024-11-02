// lib/screen/splash.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    // 스플래시 효과를 위한 지연
    await Future.delayed(const Duration(seconds: 2));

    // Firebase Auth를 통해 사용자 인증 상태 확인
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // 사용자가 로그인된 상태라면 HomeScreen으로 이동
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // 사용자가 로그인되지 않은 상태라면 Login 화면으로 이동
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Minimals App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
