// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:meditation/screens/auth/login.dart';
// import 'package:meditation/util/color.dart';
// import 'package:notification_permissions/notification_permissions.dart';

// class FCM extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<FCM> with WidgetsBindingObserver {
//   Future<String> permissionStatusFuture;
//   FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
//   var permGranted = "granted";
//   var permDenied = "denied";
//   var permUnknown = "unknown";

//   @override
//   void initState() {
//     super.initState();
//     // set up the notification permissions class
//     // set up the future to fetch the notification data
//     permissionStatusFuture = getCheckNotificationPermStatus();

//     // With this, we will be able to check if the permission is granted or not
//     // when returning to the application
//     WidgetsBinding.instance.addObserver(this);
//     firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> massage) {
//         print(massage);
//       },
//       onLaunch: (Map<String, dynamic> massage) {
//         print(massage);
//       },
//       onResume: (Map<String, dynamic> massage) {
//         print(massage);
//       },
//     );
//     firebaseMessaging.getToken().then((token) {
//       print(token);
//     });
//   }

//   /// When the application has a resumed status, check for the permission
//   /// status
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       setState(() {
//         permissionStatusFuture = getCheckNotificationPermStatus();
//       });
//     }
//   }

//   /// Checks the notification permission status
//   Future<String> getCheckNotificationPermStatus() {
//     return NotificationPermissions.getNotificationPermissionStatus()
//         .then((status) {
//       switch (status) {
//         case PermissionStatus.denied:
//           return permDenied;
//         case PermissionStatus.granted:
//           return permGranted;
//         case PermissionStatus.unknown:
//           return permUnknown;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.white,
//         body: Stack(
//           children: <Widget>[
//             Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 child: Opacity(
//                   opacity: .8,
//                   child: Image.asset(
//                     'asset/img/hill.jpeg',
//                     fit: BoxFit.fill,
//                   ),
//                 )),
//             Padding(
//                 padding: const EdgeInsets.only(top: 150, left: 150),
//                 child: Container(
//                   height: 80,
//                   width: 100,
//                   child: Image.asset(
//                     'asset/img/icon4.png',
//                     color: Colors.white,
//                   ),
//                 )),
//             Center(
//               child: Text(
//                 " Receive daily\nmotivational and\nhappiness notifications",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 28,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//             FutureBuilder(
//                 future: permissionStatusFuture,
//                 builder: (context, snapshot) {
//                   // if we are waiting for data, show a progress indicator
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator();
//                   }
//                   if (snapshot.hasData) {
//                     var textWidget = Container(
//                        decoration: BoxDecoration(
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(20)),
//                               height: 50,
//                               width: 220,
//                       margin: EdgeInsets.only(top: 630, left: 95),
//                       child: Center(
//                         child: RaisedButton(
//                                                 child: Container(
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(20)),
//                               height: 40,
//                               width: 200,
//                               child: Center(
//                                 child: Text(
//                                   "Already Enabled",
//                                   style: TextStyle(
//                                       color: primaryColor,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w300),
//                                 ),
//                               ),
//                             ),
//                           onPressed: ()
//                           {
//                             Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=>Login()));
//                           },
//                         ),
//                       ),
//                     );

//                     // The permission is granted, then just show the text
//                     if (snapshot.data == permGranted) {
//                       return textWidget;
//                     }

//                     // else, we'll show a button to ask for the permissions
//                     return Padding(
//                       padding: EdgeInsets.only(top: 580, left: 80),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: <Widget>[
//                           RaisedButton(
//                             // icon: Icon(Icons.notifications_active,color:primaryColor
//                             // ,size: 35,),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.circular(20)),
//                               height: 50,
//                               width: 220,
//                               child: Center(
//                                 child: Text(
//                                   "Enable Notifications",
//                                   style: TextStyle(
//                                       color: primaryColor,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w300),
//                                 ),
//                               ),
//                             ),
//                             color: Colors.white,
//                             onPressed: () {
//                               // show the dialog/open settings screen
//                               NotificationPermissions
//                                       .requestNotificationPermissions(
//                                           openSettings: true,
//                                           iosSettings:
//                                               const NotificationSettingsIos(
//                                                   sound: true,
//                                                   badge: true,
//                                                   alert: true))
//                                   .then((_) {
//                                 // when finished, check the permission status
//                                 setState(() {
//                                   permissionStatusFuture =
//                                       getCheckNotificationPermStatus();
//                                 });
//                               });
//                             },
//                           ),
//                           GestureDetector(
//                             child: Text(
//                               "I don't want\n\n",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w300,
//                                   fontSize: 15),
//                             ),
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   CupertinoPageRoute(
//                                       builder: (context) => Login()));
//                             },
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//                   return Text("No permission status yet");
//                 }),
//           ],
//         ),
//       ),
//     );
//   }
// }
