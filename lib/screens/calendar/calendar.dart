import 'package:flutter/material.dart';
import 'package:meditation/models/i-cal-model.dart';
import 'package:meditation/screens/calendar/calendarPm.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarCustomWidget extends StatefulWidget {
  @override
  _CalendarCustomWidgetState createState() => _CalendarCustomWidgetState();
}

class _CalendarCustomWidgetState extends State<CalendarCustomWidget> {
  @override
  Widget build(BuildContext context) {
    CalendarPm calendarPm = Provider.of<CalendarPm>(context);
    return (calendarPm.iCalModel != null)
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Card(
                  elevation: 10.0,
                  margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
                  child: SfCalendar(
                    dataSource:
                        CalDataSource(calendarPm.iCalModel.vcalendar[0].vevent),
                    view: CalendarView.month,
                    onTap: calendarPm.handleTap,
                    onViewChanged: calendarPm.onViewChange,
                    monthViewSettings: MonthViewSettings(),
                    todayHighlightColor: Theme.of(context).primaryColor,
                    headerStyle: CalendarHeaderStyle(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                        fontSize: 18.0,
                      ),
                    ),
                    viewHeaderStyle: ViewHeaderStyle(
                      dateTextStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                      ),
                      dayTextStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                      ),
                    ),
                    appointmentTextStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                    ),
                    initialDisplayDate: calendarPm.date,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Card(
                  elevation: 10.0,
                  margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
                  child: SfCalendar(
                    view: CalendarView.timelineDay,
                    controller: calendarPm.controller,
                    monthViewSettings: MonthViewSettings(),
                    dataSource:
                        CalDataSource(calendarPm.iCalModel.vcalendar[0].vevent),
                    initialDisplayDate: calendarPm.date,
                    headerStyle: CalendarHeaderStyle(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                        fontSize: 18.0,
                      ),
                    ),
                    viewHeaderStyle: ViewHeaderStyle(
                      dateTextStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                      ),
                      dayTextStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                      ),
                    ),
                    appointmentTextStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}

class CalDataSource extends CalendarDataSource {
  List<Vevent> events;
  CalDataSource(List<Vevent> source) {
    appointments = source;
    events = source;
  }

  @override
  DateTime getStartTime(int index) {
    return events[index].dtstart;
  }

  @override
  DateTime getEndTime(int index) {
    return events[index].dtend;
  }

  @override
  String getSubject(int index) {
    return events[index].description;
  }

  @override
  Color getColor(int index) {
    return events[index].color;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}
