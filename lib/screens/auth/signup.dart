import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/animation.dart';
import '../../util/color.dart';
import '../../util/gardient_animation.dart';
import '../home.dart';
import '../termsCondition.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _LoginData {
  String displayName = '';
  String email = '';
  String password = '';
}

class _SignupState extends State<Signup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  _LoginData _data = _LoginData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  backgroundImageWidget(),
                  Positioned(
                    top: 20,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FadeAnimation(
                              1.5,
                              Text(
                                "Sign Up",
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
                                child: Image.asset('asset/img/logoWhite.png',
                                    height: 150),
                              )),
                          signupFormWidget(),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Background image and logo
  Widget backgroundImageWidget() {
    return Positioned(
      top: -40,
      height: 400,
      width: MediaQuery.of(context).size.width,
      child: FadeAnimation(
        1,
        GradientAnimation(
          child: Container(),
        ),
      ),
    );
  }

//Signup form Widget
  Widget signupFormWidget() {
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
                          "Sign up",
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
                        hintText: "Full Name",
                        hintStyle: TextStyle(
                            fontSize: 15,
                            color: splashIndicatorColor.withOpacity(0.8)),
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                      ),
                      onSaved: (String value) {
                        this._data.displayName = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your name.';
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
                          return 'Please enter your email address.';
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
                        border: InputBorder.none,
                      ),
                      onSaved: (String value) {
                        this._data.password = value;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter password.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("By pressing 'submit' you agree to our"),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => TermsAndCondition()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              "terms & conditions",
                              style: TextStyle(color: Color(0xFFB74951)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  FadeAnimation(
                      1.8,
                      FloatingActionButton(
                        backgroundColor: primaryColor,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            final FirebaseUser currentUser =
                                await register(_data);
                            await _setDataUser(currentUser, _data.displayName);
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

  Future register(_data) async {
    try {
      final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
        email: _data.email,
        password: _data.password,
      ))
          .user;
      return user;
    } catch (err) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(err.message),
        duration: Duration(seconds: 4),
      ));
    }
  }

  Future _setDataUser(currentUser, displayName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var expiryDate;
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
      Firestore.instance
          .collection("fl_content")
          .document(currentUser.uid)
          .setData(
        {
          "_fl_meta_": metaData,
          "email": currentUser.email,
          "name": displayName,
          "joiningDate": DateTime.now().toString()
        },
        merge: true,
      );
      expiryDate = DateTime.now().add(new Duration(days: 7));
      prefs.setString('expiryDate', expiryDate.toString());
      prefs.setBool('isTrial', true);
    } catch (err) {
      print("Error: $err");
      throw (err);
    }
  }
}
