import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../provider/auth_provider.dart';
import '../../../util/animation.dart';
import '../../../util/color.dart';
import '../../home.dart';
import '../signup.dart';
import 'widgets/login_form.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class LoginData {
  String email = '';
  String password = '';
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  LoginData _data = new LoginData();

  AuthProvider _provider;

  // var twitterLogin = new TwitterLogin(
  //   consumerKey: GlobalConfiguration().getString("twitterConsumerKey"),
  //   consumerSecret: GlobalConfiguration().getString("twitterConsumerSecret"),
  // );

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            backgroundImageWidget(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FadeAnimation(
                      1.5,
                      Text(
                        "Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  FadeAnimation(
                      1.7,
                      Center(
                        child:
                            Image.asset('asset/img/logoWhite.png', height: 150),
                      )),
                  LoginForm(
                    scaffoldKey: _scaffoldKey,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      1.9,
                      const Text(
                        "or login with",
                        style: TextStyle(fontSize: 14),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  socialLoginWidget(),
                  const SizedBox(
                    height: 15,
                  ),
                  signupButtonWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Displaying background image and logo
  Widget backgroundImageWidget() {
    return Positioned(
      top: -40,
      height: 400,
      width: MediaQuery.of(context).size.width,
      child: FadeAnimation(
          1,
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('asset/img/loginbackground.jpg'),
                    fit: BoxFit.fill)),
          )),
    );
  }

  ///Login Button Navigate to Home screen
  Widget loginButtonWidget() {
    return Positioned(
      height: 200,
      width: MediaQuery.of(context).size.width + 20,
      child: FadeAnimation(
        1.9,
        Container(
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context, CupertinoPageRoute(builder: (context) => Home()));
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: primaryColor,
              ),
              child: Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  /// Social login button like Facebook, Twitter, Google
  Widget socialLoginWidget() {
    return FadeAnimation(
      1.9,
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Material(
                child: SvgPicture.asset(
                  'asset/img/social-icon/google.svg',
                  semanticsLabel: 'Acme Logo',
                  height: 35,
                  width: 35,
                ),
              ),
              onTap: () async {
                await Navigator.pushReplacement(
                    context, CupertinoPageRoute(builder: (context) => Home()));
              },
            ),

            // SizedBox(width: 20),
            // InkWell(
            //   child: Material(
            //     child: SvgPicture.asset(
            //       'asset/img/social-icon/twitter.svg',
            //       semanticsLabel: 'Acme Logo',
            //       height: 35,
            //       width: 35,
            //     ),
            //   ),
            //   onTap: () async {
            //     final FirebaseUser currentUser = await _handletTwitterSignIn();
            //     await _setDataUser(currentUser);
            //     await Navigator.push(
            //         context, CupertinoPageRoute(builder: (context) => Home()));
            //   },
            // ),
            // SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget signupButtonWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Don’t have an account?"),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (context) => Signup()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                "Register now",
                style: TextStyle(color: Color(0xFFB74951)),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Future<FirebaseUser> _handletTwitterSignIn() async {
  //   final TwitterLoginResult twitterAuth = await twitterLogin.authorize();
  //   FirebaseUser user;
  //   switch (twitterAuth.status) {
  //     case TwitterLoginStatus.loggedIn:
  //       final AuthCredential credential = TwitterAuthProvider.getCredential(
  //         authToken: twitterAuth.session.token,,,,.0
  //         authTokenSecret: twitterAuth.session.secret,
  //       );
  //       // Note : Flutter Engine Issue || Temp Fix
  //       // Ref: https://github.com/flutter/flutter/issues/37681
  //       // https://github.com/FirebaseExtended/flutterfire/issues/1398
  //       user = (await _auth.signInWithCredential(credential)).user;
  //       print("signed in as " + user.displayName);
  //       break;
  //     case TwitterLoginStatus.cancelledByUser:
  //       debugPrint("Twitter Canceled by user");
  //       throw (twitterAuth.errorMessage);
  //       break;
  //     case TwitterLoginStatus.error:
  //       print("Error Occurred while logging with twitter");
  //       throw (twitterAuth.errorMessage);
  //       break;
  //   }
  //   return user;
  // }

}
