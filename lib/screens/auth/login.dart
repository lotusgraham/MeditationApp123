import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation/screens/auth/forgetPassword.dart';
import 'package:meditation/screens/auth/signup.dart';
import 'package:meditation/screens/home.dart';
import 'package:meditation/util/animation.dart';
import 'package:meditation/util/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginData {
  String email = '';
  String password = '';
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  _LoginData _data = new _LoginData();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // var twitterLogin = new TwitterLogin(
  //   consumerKey: GlobalConfiguration().getString("twitterConsumerKey"),
  //   consumerSecret: GlobalConfiguration().getString("twitterConsumerSecret"),
  // );

  @override
  Widget build(BuildContext context) {
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
                  loginFormWidget(),
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

  /// login form
  Widget loginFormWidget() {
    return FadeAnimation(
        1.7,
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(196, 135, 198, .3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  FadeAnimation(
                      1.8,
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        child: Text(
                          "Login",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 55.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(color: splashIndicatorColor)),
                    child: TextFormField(
                      style: TextStyle(fontWeight: FontWeight.w600),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(
                            fontSize: 15,
                            color: splashIndicatorColor.withOpacity(0.8)),
                        icon: Icon(Icons.email),
                        border: InputBorder.none,
                      ),
                      onSaved: (String value) {
                        this._data.email = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 55.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(color: splashIndicatorColor)),
                    child: TextFormField(
                      obscureText: true,
                      style: TextStyle(fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: splashIndicatorColor.withOpacity(0.8),
                          ),
                          icon: Icon(Icons.lock),
                          border: InputBorder.none),
                      onSaved: (String value) {
                        this._data.password = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Password is required.';
                        }
                        return null;
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final showSnackBar = await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => ForgetPassword()));
                      if (showSnackBar) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                              'Follow the link sent to your email address to reset the password.'),
                          duration: Duration(seconds: 8),
                        ));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Center(
                          child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      )),
                    ),
                  ),
                  FadeAnimation(
                      1.8,
                      FloatingActionButton(
                        backgroundColor: primaryColor,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            await _handleSignIn(_data);
                            Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => Home()));
                          }
                        },
                        child: Icon(Icons.arrow_forward),
                      )),
                ],
              ),
            ),
          ),
        ));
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
              Navigator.push(
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
                final FirebaseUser currentUser = await _handleGoogleSignIn();
                print(currentUser);
                await _setDataUser(currentUser);
                await Navigator.push(
                    context, CupertinoPageRoute(builder: (context) => Home()));
              },
            ),
            SizedBox(width: 20),
            InkWell(
              child: Material(
                child: SvgPicture.asset(
                  'asset/img/social-icon/facebook.svg',
                  semanticsLabel: 'Acme Logo',
                  height: 35,
                  width: 35,
                ),
              ),
              onTap: () async {
                final FirebaseUser currentUser = await _handleFacebookSignIn();
                await _setDataUser(currentUser);
                await Navigator.push(
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

  Future<FirebaseUser> _handleGoogleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in as " + user.toString());
    return user;
  }

  Future<FirebaseUser> _handleFacebookSignIn() async {
    final FacebookLoginResult facebookAuth =
        await facebookLogin.logIn(['email']);
    FirebaseUser user;
    switch (facebookAuth.status) {
      case FacebookLoginStatus.loggedIn:
        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: facebookAuth.accessToken.token,
        );
        user = (await _auth.signInWithCredential(credential)).user;
        print("signed in as " + user.displayName);
        break;
      case FacebookLoginStatus.cancelledByUser:
        debugPrint("Facebook Canceled by user");
        throw (facebookAuth.errorMessage);
        break;
      case FacebookLoginStatus.error:
        print("Error Occurred while logging with facebook");
        throw (facebookAuth.errorMessage);
        break;
    }
    return user;
  }

  // Future<FirebaseUser> _handletTwitterSignIn() async {
  //   final TwitterLoginResult twitterAuth = await twitterLogin.authorize();
  //   FirebaseUser user;
  //   switch (twitterAuth.status) {
  //     case TwitterLoginStatus.loggedIn:
  //       final AuthCredential credential = TwitterAuthProvider.getCredential(
  //         authToken: twitterAuth.session.token,
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

  Future<FirebaseUser> _handleSignIn(_data) async {
    AuthResult firebaseAuth;
    try {
      firebaseAuth = await _auth.signInWithEmailAndPassword(
          email: _data.email, password: _data.password);
    } catch (err) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(err.message),
        duration: Duration(seconds: 5),
      ));
      throw (err);
    }
    _setDataUser(firebaseAuth.user);
    return firebaseAuth.user;
  }
}

Future _setDataUser(currentUser) async {
  Map metaData = {
    "createdBy": "0L1uQlYHdrdrG0D5CroAeybZsL33",
    "createdDate": DateTime.now(),
    "docId": currentUser.uid,
    "env": "production",
    "fl_id": currentUser.uid,
    "locale": "en-US",
    "schema": "users",
    "schemaRef": "fl_schemas/RIGJC2G8tsCBml0270IN",
    "schemaType": "collection",
  };
  try {
    if (currentUser.uid != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Firestore.instance
          .collection('fl_content')
          .where('_fl_meta_.fl_id', isEqualTo: currentUser.uid)
          .getDocuments()
          .then((QuerySnapshot snapshot) async {
        var expiryDate;

        // check if user exists.
        if (snapshot.documents.length > 0) {
          // check if user has any subscribed plan.
          if (snapshot.documents[0].data.containsKey('transaction') &&
              snapshot.documents[0].data['transaction'].length > 0) {
            expiryDate = DateTime.parse(snapshot
                            .documents[0].data['transaction']
                        [snapshot.documents[0].data['transaction'].length - 1]
                    ['expiryDate'])
                .toLocal();
            prefs.setBool('isTrial', false);
          } else {
            // else expiryDate = joingDate + 7 days.
            expiryDate =
                DateTime.parse(snapshot.documents[0].data['joiningDate'])
                    .add(new Duration(days: 7));
            prefs.setBool('isTrial', true);
          }
        } else {
          // else if the user does not exists, expiryDate = currentDate + 7 days.
          expiryDate = DateTime.now().add(new Duration(days: 7));
          Firestore.instance
              .collection("fl_content")
              .document(currentUser.uid)
              .setData({
            "_fl_meta_": metaData,
            "email": currentUser.email,
            "name": currentUser.displayName,
            "photoUrl": currentUser.photoUrl,
            "joiningDate": DateTime.now().toString()
          }, merge: true);
          prefs.setBool('isTrial', true);
        }
        // Set the expiryDate in shared preferences. To lock or unlock content.
        prefs.setString('expiryDate', expiryDate.toString());
      });
    }
  } catch (err) {
    print("Error: $err");
  }
}
