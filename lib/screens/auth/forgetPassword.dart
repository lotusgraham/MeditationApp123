import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation/util/animation.dart';
import 'package:meditation/util/color.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ResetData {
  String email = '';
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  _ResetData _data = new _ResetData();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                                "Forget Password",
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

  /// Registration form field
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
                          "Enter your email address below.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )),
                  FadeAnimation(
                      1.8,
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        child: Text(
                          "and we'll send you an email allowing you to reset the password.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
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
                  InkWell(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        try {
                          await _auth.sendPasswordResetEmail(
                              email: _data.email);
                          Navigator.pop(context, true);
                        } catch (err) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(err.message),
                            duration: Duration(seconds: 5),
                          ));
                        }
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(30)),
                        alignment: Alignment.center,
                        child: Text(
                          "SEND EMAIL",
                          style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context, false);
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryColor, width: 2.0),
                            borderRadius: BorderRadius.circular(30)),
                        alignment: Alignment.center,
                        child: Text(
                          "CANCEL",
                          style: TextStyle(
                              color: splashIndicatorColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ));
  }
}
