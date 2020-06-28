import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation/screens/home/home.dart';
import 'package:meditation/screens/welcome-screen.dart';
import 'package:meditation/util/animation.dart';
import 'package:meditation/util/color.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      _auth.currentUser().then((FirebaseUser user) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) {
            if (user != null) {
              return HomeWrapper();
            } else {
              return WelcomeScreen();
            }
          }),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: FadeAnimation(
            0.5,
            Center(
              child: Image.asset('asset/img/logoWhite.png',
                  width: 190, height: 200),
            )),
      ),
    );
  }
}
