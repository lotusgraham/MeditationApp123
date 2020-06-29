import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:meditation/screens/calendar/calendar.dart';
import 'package:meditation/screens/calendar/calendarPm.dart';
import 'package:meditation/screens/home/homePm.dart';
import 'package:meditation/util/onWillPop.dart';
import 'package:provider/provider.dart';
import 'package:meditation/chat/ChatPage.dart';
import 'package:meditation/screens/reminder/alarm.dart';
import 'package:meditation/screens/setting.dart';
import 'package:meditation/util/color.dart';
import 'package:meditation/util/gardient_animation.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeWrapper extends StatefulWidget {
  final bool isPaymentSuccess;
  final String plan;

  const HomeWrapper({Key key, this.isPaymentSuccess, this.plan})
      : super(key: key);

  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomePm(context),
      builder: (c, _) {
        return Home();
      },
    );
  }
}

class Home extends StatefulWidget {
  final bool isPaymentSuccess;
  final String plan;

  const Home({Key key, this.isPaymentSuccess, this.plan}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  List<Widget> pages = [];
  FirebaseMessaging firebaseMessaging;
  @override
  initState() {
    super.initState();
    this.firebaseMessaging = new FirebaseMessaging();
    // Show payment success alert.
    if (widget.isPaymentSuccess != null && widget.isPaymentSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Alert(
          context: context,
          type: AlertType.success,
          title: "Success",
          desc:
              "You've successfully subscribed to our ${widget.plan} package. To check your subscrition details goto account page under settings tab.",
          buttons: [
            DialogButton(
              child: Text(
                "Okay",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      });
    }
    WidgetsBinding.instance.addObserver(this);
  }

  configure() {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> massage) async {
        showNotification(massage);
        print(massage);
        print("Foreground notification");
      },
      // onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> massage) async {
        print(massage);
      },
      onResume: (Map<String, dynamic> massage) async {
        print(massage);
      },
    );
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = new AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //for Foreground notification
  Future showNotification(massage) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    // var iOS =
    //     new IOSNotificationDetails(presentAlert: true, presentBadge: true);
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        2,
        '${massage['notification']['title']}',
        '${massage['notification']['body']}',
        platform,
        payload: '');
  }

  @override
  Widget build(BuildContext context) {
    HomePm homePm = Provider.of<HomePm>(context);

    appBarWidget() {
      return Positioned(
          top: -10,
          height: 270,
          width: MediaQuery.of(context).size.width,
          child: GradientAnimation(
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[]))));
    }

    buildGuidedMeditation() {
      return Container(
        width: MediaQuery.of(context).size.width - 40,
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: YoutubePlayer(
            controller: homePm.controller,
            showVideoProgressIndicator: true,
            bufferIndicator: CircularProgressIndicator(),
          ),
        ),
      );
    }

    CurvedNavigationBar buildBottomNavigationBar() {
      return CurvedNavigationBar(
        height: 60.0,
        color: primaryColor,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: primaryColor,
        items: [
          Icon(Icons.home, color: iconColor),
          Icon(Icons.calendar_today, color: iconColor),
          Icon(Icons.alarm, color: iconColor),
          Icon(Icons.chat, color: iconColor),
          Icon(Icons.settings, color: iconColor),
        ],
        onTap: homePm.changeSelectedPage,
      );
    }

    Widget categories() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Guided Meditations",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const Text("Listen to a soothing audio recording...",
                style: TextStyle(fontSize: 12)),
            const SizedBox(height: 20),
            homePm.categoryList.length > 0
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: homePm.categoryList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.5, crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      dynamic cl = homePm.categoryList[index];
                      return GestureDetector(
                        child: Hero(
                          tag: cl['id'],
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 20, left: 10, right: 10),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 6),
                            child: Text(cl['name'],
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: textColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              image: DecorationImage(
                                  image: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/${GlobalConfiguration().getString("firebaseProjectID")}.appspot.com/o/flamelink%2Fmedia%2F${cl['coverImage']}?alt=media",
                                  ),
                                  alignment: Alignment.centerRight,
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onTap: () => homePm.onCategorySelect(cl),
                      );
                    })
                : SizedBox(
                    height: 100.0,
                    child: Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: darkPrimaryColor,
                      child: Center(
                        child: Image.asset(
                          'asset/img/logo-with-text.png',
                          height: 100.0,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      );
    }

    Widget featuresStories() {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 20),
              child: Text("Featured stories",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            Container(
              height: 100,
              padding: EdgeInsets.only(left: 10.0),
              child: homePm.featuredStoryList.length > 0
                  ? ListView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      children: homePm.featuredStoryList.map((dynamic fsl) {
                        return GestureDetector(
                          child: Container(
                              height: 90,
                              width: 162,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              padding: const EdgeInsets.only(top: 15, left: 20),
                              child: Text(fsl['name'],
                                  style: TextStyle(
                                      color: textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        "https://firebasestorage.googleapis.com/v0/b/${GlobalConfiguration().getString("firebaseProjectID")}.appspot.com/o/flamelink%2Fmedia%2F${fsl['coverImage']}?alt=media",
                                      ),
                                      alignment: Alignment.centerRight,
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(10))),
                          onTap: () => homePm.onStorySelect(fsl),
                        );
                      }).toList())
                  : SizedBox(
                      height: 100.0,
                      child: Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: darkPrimaryColor,
                        child: Center(
                          child: Image.asset(
                            'asset/img/logo-with-text.png',
                            height: 100.0,
                          ),
                        ),
                      ),
                    ),
            )
          ],
        ),
      );
    }

    buildWidget() {
      return Positioned(
        top: MediaQuery.of(context).size.height * 0.02,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset(
                'asset/img/logoWhite.png',
                height: 150,
                width: 190,
              ),
            ),
            SizedBox(height: 20),
            buildGuidedMeditation(),
            SizedBox(height: 30),
            featuresStories(),
            SizedBox(height: 30),
            categories(),
          ],
        ),
      );
    }

    Widget _page1 = SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height +
            120 * (homePm.categoryList.length / 2).round().toDouble(),
        child: Stack(
          children: <Widget>[
            appBarWidget(),
            buildWidget(),
          ],
        ),
      ),
    );
    pages = [
      _page1,
      ChangeNotifierProvider(
        create: (context) => CalendarPm(),
        child: CalendarCustomWidget(),
      ),
      Alarm(),
      Chat(),
      Setting(),
    ];

    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            IndexedStack(
              index: homePm.selectedIndex,
              children: pages,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: buildBottomNavigationBar(),
            )
          ],
        ),
      ),
    );
  }
}
