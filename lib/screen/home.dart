// lib/screen/home.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'login.dart'; // 로그인 화면으로 이동하기 위해 추가

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // 비동기 작업 후에 BuildContext를 사용
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Login()),
        );
      } else {
        // 추가적인 초기화 작업이 필요한 경우 여기에 작성
        if (mounted) {
          setState(() {
            _isFetching = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isFetching = false;
        });
      }
      // 에러 처리 (예: Snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사용자 정보를 가져오는 데 실패했습니다.')),
      );
      print('사용자 확인 에러: $e');
    }
  }

  Future<void> naverlogout() async {
    FlutterNaverLogin.logOut().then((value) => {
          print("logout successful"),
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const Login(),
          ))
        });
  }

  Future<void> logout() async {
    bool logoutSuccessful = false;

    try {
      await UserApi.instance.logout();
      await naverlogout();
      logoutSuccessful = true;
      print('Kakao 로그아웃 성공');
    } catch (error) {
      print('Kakao 로그아웃 실패: $error');
    }

    try {
      await FirebaseAuth.instance.signOut();
      logoutSuccessful = true;
    } catch (error) {
      print('Firebase 로그아웃 실패: $error');
    }

    // 로그아웃 성공 시 로그인 화면으로 이동
    if (logoutSuccessful) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } else {
      // 로그아웃 실패 시 사용자에게 알림
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그아웃에 실패했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetching) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout, // 로그아웃 함수 연결
            tooltip: '로그아웃',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            user?.photoURL != null
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user!.photoURL!),
                  )
                : const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
            const SizedBox(height: 20),
            Text(
              '환영합니다, ${user?.displayName ?? '사용자'}님!',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              '이메일: ${user?.email ?? '이메일 정보 없음'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
