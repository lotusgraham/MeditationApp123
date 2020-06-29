import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
// import 'package:html/dom.dart' show Node;
import 'package:meditation/models/i-cal-model.dart';
import 'package:meditation/screens/calendar/calendarPm.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:html/parser.dart';

class CalendarCustomWidget extends StatefulWidget {
  @override
  _CalendarCustomWidgetState createState() => _CalendarCustomWidgetState();
}

class _CalendarCustomWidgetState extends State<CalendarCustomWidget> {
  @override
  Widget build(BuildContext context) {
    CalendarPm calendarPm = Provider.of<CalendarPm>(context);
    handleTap(CalendarTapDetails details) {
      if (details.appointments != null) {
        showDialog(
          context: context,
          builder: (c) {
            List l = details.appointments;
            l.sort((a, b) {
              DateTime astart = a.dtstart;
              DateTime bstart = b.dtstart;
              return astart.compareTo(bstart);
            });
            return SimpleDialog(
              // useMaterialBorderRadius: true,
              children: l.map((v) {
                DateTime dtstart = v.dtstart;
                DateTime dtend = v.dtend;

                return Card(
                  elevation: 10.0,
                  child: ListTile(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          color: v.color,
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Starts at - " +
                                  DateFormat('hh:mm a').format(dtstart),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        Html(
                          data: v.description
                              .toString()
                              .trim()
                              .replaceAll("\\", ""),
                          defaultTextStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                          onLinkTap: (String link) async {
                            if (await canLaunch(link)) {
                              launch(link);
                            }
                          },
                        ),
                        Card(
                          color: v.color,
                          margin: EdgeInsets.only(top: 10.0),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Ends at - " +
                                  DateFormat('hh:mm a').format(dtend),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              titlePadding: EdgeInsets.all(15.0),
              contentPadding: EdgeInsets.all(5.0),
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Text(
                "Events on\n" +
                    "" +
                    DateFormat('dd-MM-yyyy').format(details.date),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                  fontSize: 18.0,
                ),
              ),
            );
          },
        );
      }
    }

    DropdownMenuItem item(String text, CalendarView view) {
      return DropdownMenuItem(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColor,
            fontSize: 18.0,
          ),
        ),
        value: view,
      );
    }

    Widget viewSwitcher() {
      return DropdownButton(
        items: [
          item("Month View", CalendarView.month),
          item("Week View", CalendarView.week),
          item("Day View", CalendarView.day),
          item("Timeline (Day)", CalendarView.timelineDay),
          item("Timeline (Month)", CalendarView.timelineWeek),
        ],
        onChanged: (view) {
          calendarPm.changeView(view);
        },
        value: calendarPm.view,
      );
    }

    return SafeArea(
      child: (calendarPm.iCalModel != null)
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                    child: viewSwitcher(),
                  ),
                  Flexible(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Card(
                        elevation: 10.0,
                        margin:
                            EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
                        child: SfCalendar(
                          dataSource: CalDataSource(
                              calendarPm.iCalModel.vcalendar[0].vevent),
                          controller: calendarPm.controller,
                          view: calendarPm.view,
                          onTap: handleTap,
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
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  )
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
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
