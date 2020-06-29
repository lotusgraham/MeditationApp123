import 'package:flutter/material.dart';
import 'package:meditation/screens/reminder/clock/clock.dart';

class Reminder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 56),
          child: Clock(),
        ),
        SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Reach your goal by setting a",
                  //"Meditate",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xffff0863),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  //"06:12 PM",
                  "Daily Reminder",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff2d386b),
                      fontSize: 30,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: <Widget>[
            //     Text(
            //       "Time Left",
            //       style: TextStyle(
            //           color: Color(0xffff0863),
            //           fontSize: 12,
            //           fontWeight: FontWeight.w700,
            //           letterSpacing: 1.3),
            //     ),
            //     SizedBox(
            //       height: 10,
            //     ),
            //     Text(
            //       "08:00 AM",
            //       style: TextStyle(
            //           color: Color(0xff2d386b),
            //           fontSize: 30,
            //           fontWeight: FontWeight.w700),
            //     )
            //   ],
            // ),
          ],
        )
      ],
    );
  }
}
