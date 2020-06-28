import 'dart:convert';
import 'dart:math';
import 'package:meditation/enums/gradient_animation_enum.dart';
import 'package:meditation/util/gardient_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
// import 'package:meditation/screens/reminder/reminder-stats.dart';
import 'package:meditation/screens/reminder/reminder.dart';
import 'package:meditation/util/color.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simple_animations/simple_animations.dart';

Time timeofalarm;
var showtime;
List<String> multipleAlarm = [];
Color mainColor = Color(0xFFf45905);

class Alarm extends StatefulWidget {
  @override
  _AlarmState createState() => _AlarmState();
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class _AlarmState extends State<Alarm> {
  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = new AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    var initializationSettingsIOS = new IOSInitializationSettings(
        // onDidReceiveLocalNotification: onDidReceiveLocalNotification
        );
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    getalarmtime();
  }

  getalarmtime() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();

    setState(() {
      if (myPrefs.getStringList("multipleAlarm") != null) {
        multipleAlarm = myPrefs.getStringList("multipleAlarm");
      }
    });
  }

  selecttime(BuildContext context) async {
    // TimeOfDay selectedTimeRTL = await showTimePicker(
    //   context: context,
    //   initialTime: TimeOfDay.now(),
    //   builder: (BuildContext context, Widget child) {
    //     return Container(color: Colors.blue, child: child);
    //   },
    // );
    TimeOfDay selectedTimeRTL = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTimeRTL != null) {
      int hour = selectedTimeRTL.hour;
      int min = selectedTimeRTL.minute;
      print(selectedTimeRTL.hashCode);
      print("============>$hour");
      print("============>$min ");
      timeofalarm = Time(hour, min, 0);
      setState(() {
        showtime = TimeOfDay(hour: hour, minute: min).format(context);
      });
      SharedPreferences myPrefs = await SharedPreferences.getInstance();

      if (!multipleAlarm
          .any((alarm) => alarm.contains('${selectedTimeRTL.hashCode}'))) {
        var data =
            jsonEncode({'id': selectedTimeRTL.hashCode, 'time': showtime});

        multipleAlarm.add(data);
        myPrefs.setStringList("multipleAlarm", multipleAlarm);
        // myPrefs.setString('alarm_time', '$showtime');

        if (timeofalarm != null) {
          scheduledalarm(selectedTimeRTL.hashCode, timeofalarm);
          snackbar('Daily reminder set for $showtime.');
        }
      } else {
        snackbar('Reminder Already exist for $showtime');
      }
    }
  }

  snackbar(String text) {
    final snackBar = SnackBar(
      content: Text('$text '),
      duration: Duration(seconds: 2),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  scheduledalarm(int id, var timeofalarm) async {
    var scheduledNotificationDateTime =
        Time(timeofalarm.hour, timeofalarm.minute);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your  channel name', 'your  channel description',
        sound: RawResourceAndroidNotificationSound("sd"),
        autoCancel: true,
        playSound: true,
        color: primaryColor,
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(sound: "sd.aiff", presentSound: true);

    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        //for multiple alarm give unique id each time as--> DateTime.now().millisecond,
        id,
        'Time to meditate',
        '$showtime',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
    print("alarm set");
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    // showDialog(
    //   context: context,
    //   builder: (_) => Container()
    //   // new AlertDialog(
    //   //   title: new Text('Alarm'),
    //   //   content: new Text('$alarmtime'),
    //   // ),
    // );
  }

  showNotification() async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'New Notification', 'Flutter Local Notification', platform,
        payload: 'your alarm ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Positioned.fill(child: BackGroundAnimation(child: null)),
        onBottom(AnimatedWave(
          height: 200,
          speed: 1.0,
        )),
        onBottom(AnimatedWave(
          height: 140,
          speed: 0.9,
          offset: pi,
        )),
        onBottom(AnimatedWave(
          height: 240,
          speed: 1.2,
          offset: pi / 2,
        )),
        SafeArea(
          child: Column(
            children: <Widget>[
              AppBar(
                  backgroundColor: Colors.transparent,
                  titleSpacing: 10.0,
                  automaticallyImplyLeading: false,
                  title: RichText(
                    text: TextSpan(children: [
                      TextSpan(text: "\n"),
                      TextSpan(
                        text: "Set Reminder",
                        style: TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: "\n"),
                      TextSpan(
                        text:
                            "The people who set reminder achieve their goals twice as fast.",
                        style:
                            TextStyle(color: Color(0xFF1A1A1A), fontSize: 12),
                      )
                    ]),
                  ),
                  elevation: 0.0),
              SizedBox(
                height: 16,
              ),
              Reminder(),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * .04,
              // ),
              SizedBox(
                height: 16,
              ),
              multipleAlarm != null
                  ? Flexible(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: multipleAlarm.length,
                        itemBuilder: (context, index) {
                          var alarm = jsonDecode(multipleAlarm[index]);

                          return Dismissible(
                            secondaryBackground: Container(
                                margin: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    // color: primaryColor,
                                    gradient: LinearGradient(colors: [
                                      primaryColor,
                                      Colors.pink[500],
                                    ])),
                                padding: EdgeInsets.only(right: 20),
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                )),
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) async {
                              SharedPreferences myPrefs =
                                  await SharedPreferences.getInstance();

                              await flutterLocalNotificationsPlugin.cancel(
                                  jsonDecode(multipleAlarm[index])['id']);
                              multipleAlarm.removeAt(index);
                              myPrefs.setStringList(
                                  "multipleAlarm", multipleAlarm);

                              setState(() {
                                multipleAlarm =
                                    myPrefs.getStringList("multipleAlarm");
                              });

                              snackbar(
                                  "Reminder for ${alarm['time']} is removed !");
                            },
                            background: Container(color: primaryColor),
                            child: Container(
                              margin: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                      colors: [primaryColor, Colors.blue])),
                              child: ListTile(
                                title: Text(
                                  "${alarm['time']}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : SizedBox(),
              Container(
                padding: EdgeInsets.only(top: 16, right: 16),
                alignment: Alignment.bottomRight,
                child: FloatingActionButton.extended(
                  heroTag: UniqueKey,
                  label: Icon(
                    Icons.add,
                    color: Color(0xff2d386b),
                    size: 20,
                  ),
                  backgroundColor: Colors.white,
                  onPressed: () => selecttime(context),
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ],
    ));
  }

  onBottom(Widget child) => Positioned.fill(
          child: Align(
        alignment: Alignment.bottomCenter,
        child: child,
      ));
}

class BackGroundAnimation extends StatelessWidget {
  const BackGroundAnimation({Key key, @required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final _tween = MultiTween()
      ..add(
        GradientAnimationEnum.left,
        ColorTween(begin: Colors.lightBlue[200], end: Colors.deepPurple[200]),
      )
      ..add(
        GradientAnimationEnum.right,
        ColorTween(begin: Colors.indigo[200], end: Colors.lightBlue[200]),
      );

    return CustomAnimation(
      control: CustomAnimationControl.MIRROR,
      duration: const Duration(seconds: 5),
      tween: _tween,
      child: child,
      builder: (context, child, value) {
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              value.get(GradientAnimationEnum.left),
              value.get(GradientAnimationEnum.right),
            ]),
          ),
          child: child,
        );
      },
    );
  }
}

class AnimatedWave extends StatelessWidget {
  final double height;
  final double speed;
  final double offset;

  AnimatedWave({this.height, this.speed, this.offset = 0.0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: height,
        width: constraints.biggest.width,
        child: ControlledAnimation(
            playback: Playback.LOOP,
            duration: Duration(milliseconds: (5000 / speed).round()),
            tween: Tween(begin: 0.0, end: 2 * pi),
            builder: (context, value) {
              return CustomPaint(
                foregroundPainter: CurvePainter(value + offset),
              );
            }),
      );
    });
  }
}

class CurvePainter extends CustomPainter {
  final double value;

  CurvePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.indigo[300].withAlpha(50);
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
