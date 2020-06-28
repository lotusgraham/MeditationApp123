import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:meditation/models/i-cal-model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;

class CalendarPm extends ChangeNotifier {
  String jsonLink =
      'https://firebasestorage.googleapis.com/v0/b/joyhome-cd900.appspot.com/o/flamelink%2Fmedia%2Fcalendar.json?alt=media';
  ICalModel iCalModel;
  List<Vevent> events;
  CalendarController controller;
  CalendarView view;
  DateTime date;
  CalendarPm() {
    this.loadData();
    this.view = CalendarView.month;
    this.controller = CalendarController();
  }

  loadData() {
    http.get(jsonLink).then((http.Response response) {
      iCalModel = ICalModel.fromJson(jsonDecode(response.body));
      _notify();
    });
  }

  changeView(CalendarView v) {
    this.view = v;
    _notify();
  }

  onViewChange(ViewChangedDetails details) {}

  _notify() {
    try {
      if (this.hasListeners) {
        notifyListeners();
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    super.dispose();
  }
}
