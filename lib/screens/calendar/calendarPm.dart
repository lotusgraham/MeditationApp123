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
    this.view = CalendarView.day;
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

  handleTap(CalendarTapDetails details) {
    print(details.date);
    if (details.date != null) {
      this.view = CalendarView.day;
      this.date = details.date;
      this.controller.selectedDate = details.date;
      _notify();
    } else {
      this.view = CalendarView.month;
      _notify();
    }
  }

  _notify() {
    if (this.hasListeners) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
