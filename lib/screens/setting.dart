import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation/screens/auth/login.dart';
import 'package:meditation/screens/edit-profile.dart';
import 'package:meditation/screens/invite-firends.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation/screens/payment/subscription.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meditation/screens/reminder/alarm.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Settings",
              style: TextStyle(color: Color(0xFF1A1A1A), fontSize: 24)),
          elevation: 0.0),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Ink(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, .2),
                        blurRadius: 20.0,
                        offset: Offset(0, 10))
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => EditProfile()),
                    );
                  },
                  child: ListTile(
                    leading: Icon(Icons.account_box, color: Color(0xFF727C8E)),
                    title: Text(
                      'Account',
                      style: TextStyle(fontSize: 14, color: Color(0xFF212121)),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Ink(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, .2),
                        blurRadius: 20.0,
                        offset: Offset(0, 10))
                  ]),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => Invite()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.share, color: Color(0xFF727C8E)),
                    title: Text(
                      'Say to Friends',
                      style: TextStyle(fontSize: 14, color: Color(0xFF212121)),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            // InkWell(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       CupertinoPageRoute(builder: (context) => Subscription()),
            //     );
            //   },
            //   child: Container(
            //     decoration: BoxDecoration(border: Border(bottom: BorderSide())),
            //     padding: const EdgeInsets.only(left: 25, bottom: 20, top: 20),
            //     child: Row(
            //       children: <Widget>[
            //         Icon(Icons.share, color: Color(0xFF727C8E)),
            //         const SizedBox(width: 16),
            //         Text(
            //           'Subscription',
            //           style: TextStyle(fontSize: 14, color: Color(0xFF212121)),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   decoration: BoxDecoration(border: Border(bottom: BorderSide())),
            //   padding: const EdgeInsets.only(left: 25, bottom: 20, top: 20),
            //   child: Row(
            //     children: <Widget>[
            //       Icon(Icons.notifications, color: Color(0xFF727C8E)),
            //       const SizedBox(width: 16),
            //       Text(
            //         'Notifications',
            //         style: TextStyle(fontSize: 14, color: Color(0xFF212121)),
            //       )
            //     ],
            //   ),
            // ),
            Ink(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, .2),
                        blurRadius: 20.0,
                        offset: Offset(0, 10))
                  ]),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () async {
                  //navigate lo login screen
                  await _auth.signOut().whenComplete(() {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(builder: (context) => Login()),
                    );

                    joindate = null;
                    username = null;
                  });

                  SharedPreferences myPrefs =
                      await SharedPreferences.getInstance();
                  List checkalarmset = myPrefs.getStringList('multipleAlarm');
                  if (checkalarmset != null) {
                    myPrefs.remove('multipleAlarm');
                    await flutterLocalNotificationsPlugin.cancelAll();
                    multipleAlarm.clear();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.power_settings_new,
                        color: Color(0xFF727C8E)),
                    title: Text(
                      'Log Out',
                      style: TextStyle(fontSize: 14, color: Color(0xFF212121)),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final Widget child;

  const CustomContainer({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(143, 148, 251, .2),
                  blurRadius: 20.0,
                  offset: Offset(0, 10))
            ]),
        child: child,
      ),
    );
  }
}
