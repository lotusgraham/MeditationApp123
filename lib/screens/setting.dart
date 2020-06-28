import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation/screens/auth/login/login.dart';
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
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => EditProfile()),
                );
              },
              child: Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                padding: const EdgeInsets.only(left: 25, bottom: 20, top: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.account_box, color: Color(0xFF727C8E)),
                    const SizedBox(width: 16),
                    Text(
                      'Account',
                      style: TextStyle(fontSize: 14, color: Color(0xFF212121)),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => Invite()),
                );
              },
              child: Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                padding: const EdgeInsets.only(left: 25, bottom: 20, top: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.share, color: Color(0xFF727C8E)),
                    const SizedBox(width: 16),
                    Text(
                      'Say to Friends',
                      style: TextStyle(fontSize: 14, color: Color(0xFF212121)),
                    )
                  ],
                ),
              ),
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
            InkWell(
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
              child: Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                padding: const EdgeInsets.only(left: 25, bottom: 20, top: 20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.power_settings_new, color: Color(0xFF727C8E)),
                    const SizedBox(width: 16),
                    Text(
                      'Log Out',
                      style: TextStyle(fontSize: 14, color: Color(0xFF212121)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
