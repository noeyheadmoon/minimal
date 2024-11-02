// lib/screen/login.dart
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:minimals/screen/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          // Center 위젯으로 전체 콘텐츠를 중앙에 배치
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Column의 크기를 자식에 맞게 최소화
              children: [
                Text(
                  "지금 가입하고 우리 애기 돌보러 가기",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24, // 큰 글씨 크기
                    fontWeight: FontWeight.bold, // 굵은 글씨
                    color: Colors.black87, // 텍스트 색상
                  ),
                ),
                SizedBox(height: 40), // 후킹 멘트와 버튼 사이 간격

                // 이미지 추가
                Image.asset(
                  'images/loginpage_animals.jpg', // 여기에 실제 이미지 경로를 입력하세요
                  height: 200, // 원하는 이미지 높이로 조정
                  fit: BoxFit.contain, // 이미지 크기 조정 방식
                ),
                SizedBox(height: 40), // 이미지와 버튼 사이 간격

                // Google Sign-In Button
                InkWell(
                  onTap: () {
                    signInWithGoogle();
                  },
                  child: Card(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    elevation: 2,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/google.png',
                            height: 30,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Google로 시작하기",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                              fontWeight: FontWeight.bold, // 굵은 글씨
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Apple Sign-In Button (iOS 전용)
                if (Platform.isIOS)
                  InkWell(
                    onTap: () {
                      // signInWithApple(); // Apple 로그인 함수 구현 필요
                    },
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      elevation: 2,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/apple.png',
                              height: 30,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Apple로 시작하기",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold, // 굵은 글씨
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                // Kakao 및 Naver 로그인 버튼
                getKakaoLoginButton(),
                getNaverLoginButton(),
                SizedBox(height: 20),
                // 로딩 인디케이터 표시
                if (_isLoading) ...[
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getNaverLoginButton() {
    return InkWell(
      onTap: () {
        //thing to do
        signInWithNaver();
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        elevation: 2,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 3, 199, 90),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/naver.png', height: 50),
              const SizedBox(
                width: 10,
              ),
              const Text("네이버로 시작하기",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }

  Widget getKakaoLoginButton() {
    return InkWell(
      onTap: () {
        //thing to do
        signInWithKakao();
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        elevation: 2,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/kakao.png', height: 30),
              const SizedBox(
                width: 10,
              ),
              const Text("카카오톡으로 시작하기",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Google 인증 플로우 트리거
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // 사용자가 로그인 취소
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 인증 정보 획득
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 새 자격 증명 생성
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase에 자격 증명으로 로그인
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print(userCredential.user?.email);

      // 로그인 성공 후 홈 화면으로 이동
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomeScreen(), // MyApp 대신 HomeScreen으로 변경
      ));
    } catch (e) {
      print("error $e");
      // 에러 처리 (예: Snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google 로그인 중 오류가 발생했습니다.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> signInWithNaver() async {
    await FlutterNaverLogin.logIn().then((value) async {
      print('value from naver $value');

      NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
      var accesToken = res.accessToken;

      var tokenType = res.tokenType;

      print("accesToken $accesToken");
      print("tokenType $tokenType");

      navigateToMainPage();
    });
  }

  Future<void> signInWithKakao() async {
    // 카카오 로그인 구현 예제
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk().then((value) {
          print('value from kakao $value');
          navigateToMainPage();
        });
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount().then((value) {
            print('value from kakao $value');
            navigateToMainPage();
          });
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        var provider = OAuthProvider("oidc.minimals");
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        var credential = provider.credential(
          idToken: token.idToken,
          accessToken: token.accessToken,
        );
        FirebaseAuth.instance.signInWithCredential(credential).then((value) {
          print('value from kakao $value');
          navigateToMainPage();
        });
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  void navigateToMainPage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const HomeScreen(), // MyApp 대신 HomeScreen으로 변경
    ));
  }
}
