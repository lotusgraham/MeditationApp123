import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> onWillPop(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext c) {
      return AlertDialog(
        title: Text('Exit'),
        content: Text('Do you want to exit the app?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () =>
                SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
}
