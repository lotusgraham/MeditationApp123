import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation/util/animation.dart';
import 'package:meditation/util/color.dart';
import 'package:provider/provider.dart';

import '../../../home.dart';
import '../../forgetPassword.dart';
import '../../../../provider/auth_provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key key,
    @required this.scaffoldKey,
  }) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email, password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
                        email = value;
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
                        password = value;
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
                        widget.scaffoldKey.currentState.showSnackBar(SnackBar(
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
                            Provider.of<AuthProvider>(context, listen: false)
                                .handleSignIn(
                                  email,
                                  password,
                                  widget.scaffoldKey,
                                )
                                .then(
                                  (value) => Navigator.pushReplacement(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => Home(),
                                    ),
                                  ),
                                );
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
}
