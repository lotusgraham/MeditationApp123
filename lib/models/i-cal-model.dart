import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class ICalModel {
  List<Vcalendar> vcalendar;
  bool success;

  ICalModel({this.vcalendar, this.success});

  ICalModel.fromJson(Map<String, dynamic> json) {
    if (json['vcalendar'] != null) {
      vcalendar = new List<Vcalendar>();
      json['vcalendar'].forEach((v) {
        vcalendar.add(new Vcalendar.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vcalendar != null) {
      data['vcalendar'] = this.vcalendar.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class Vcalendar {
  String prodid;
  String version;
  String calscale;
  String method;
  String xWrCalname;
  String xWrTimezone;
  List<Vtimezone> vtimezone;
  List<Vevent> vevent;

  Vcalendar(
      {this.prodid,
      this.version,
      this.calscale,
      this.method,
      this.xWrCalname,
      this.xWrTimezone,
      this.vtimezone,
      this.vevent});

  Vcalendar.fromJson(Map<String, dynamic> json) {
    prodid = json['prodid'];
    version = json['version'];
    calscale = json['calscale'];
    method = json['method'];
    xWrCalname = json['x-wr-calname'];
    xWrTimezone = json['x-wr-timezone'];
    if (json['vtimezone'] != null) {
      vtimezone = new List<Vtimezone>();
      json['vtimezone'].forEach((v) {
        vtimezone.add(new Vtimezone.fromJson(v));
      });
    }
    if (json['vevent'] != null) {
      vevent = new List<Vevent>();
      json['vevent'].forEach((v) {
        vevent.add(new Vevent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prodid'] = this.prodid;
    data['version'] = this.version;
    data['calscale'] = this.calscale;
    data['method'] = this.method;
    data['x-wr-calname'] = this.xWrCalname;
    data['x-wr-timezone'] = this.xWrTimezone;
    if (this.vtimezone != null) {
      data['vtimezone'] = this.vtimezone.map((v) => v.toJson()).toList();
    }
    if (this.vevent != null) {
      data['vevent'] = this.vevent.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vtimezone {
  String tzid;
  String xLicLocation;
  List<Daylight> daylight;
  List<Standard> standard;

  Vtimezone({this.tzid, this.xLicLocation, this.daylight, this.standard});

  Vtimezone.fromJson(Map<String, dynamic> json) {
    tzid = json['tzid'];
    xLicLocation = json['x-lic-location'];
    if (json['daylight'] != null) {
      daylight = new List<Daylight>();
      json['daylight'].forEach((v) {
        daylight.add(new Daylight.fromJson(v));
      });
    }
    if (json['standard'] != null) {
      standard = new List<Standard>();
      json['standard'].forEach((v) {
        standard.add(new Standard.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tzid'] = this.tzid;
    data['x-lic-location'] = this.xLicLocation;
    if (this.daylight != null) {
      data['daylight'] = this.daylight.map((v) => v.toJson()).toList();
    }
    if (this.standard != null) {
      data['standard'] = this.standard.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Daylight {
  String tzoffsetfrom;
  String tzoffsetto;
  String tzname;
  String dtstart;
  Rrule rrule;

  Daylight(
      {this.tzoffsetfrom,
      this.tzoffsetto,
      this.tzname,
      this.dtstart,
      this.rrule});

  Daylight.fromJson(Map<String, dynamic> json) {
    tzoffsetfrom = json['tzoffsetfrom'];
    tzoffsetto = json['tzoffsetto'];
    tzname = json['tzname'];
    dtstart = json['dtstart'];
    rrule = json['rrule'] != null ? new Rrule.fromJson(json['rrule']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tzoffsetfrom'] = this.tzoffsetfrom;
    data['tzoffsetto'] = this.tzoffsetto;
    data['tzname'] = this.tzname;
    data['dtstart'] = this.dtstart;
    if (this.rrule != null) {
      data['rrule'] = this.rrule.toJson();
    }
    return data;
  }
}

class Rrule {
  String freq;
  String bymonth;
  String byday;

  Rrule({this.freq, this.bymonth, this.byday});

  Rrule.fromJson(Map<String, dynamic> json) {
    freq = json['freq'];
    bymonth = json['bymonth'];
    byday = json['byday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['freq'] = this.freq;
    data['bymonth'] = this.bymonth;
    data['byday'] = this.byday;
    return data;
  }
}

class Standard {
  String tzoffsetfrom;
  String tzoffsetto;
  String tzname;
  String dtstart;
  String rrule;

  Standard(
      {this.tzoffsetfrom,
      this.tzoffsetto,
      this.tzname,
      this.dtstart,
      this.rrule});

  Standard.fromJson(Map<String, dynamic> json) {
    tzoffsetfrom = json['tzoffsetfrom'];
    tzoffsetto = json['tzoffsetto'];
    tzname = json['tzname'];
    dtstart = json['dtstart'];
    rrule = json['rrule'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tzoffsetfrom'] = this.tzoffsetfrom;
    data['tzoffsetto'] = this.tzoffsetto;
    data['tzname'] = this.tzname;
    data['dtstart'] = this.dtstart;
    data['rrule'] = this.rrule;
    return data;
  }
}

class Vevent {
  DateTime dtstart;
  DateTime dtend;
  Rrule rrule;
  String dtstamp;
  String uid;
  String attendee;
  String created;
  String description;
  Color color =
      RandomColor().randomColor(colorBrightness: ColorBrightness.dark);
  String lastModified;
  String location;
  String sequence;
  String status;
  String summary;
  String transp;
  String recurrenceId;

  Vevent(
      {this.dtstart,
      this.rrule,
      this.dtstamp,
      this.uid,
      this.attendee,
      this.created,
      this.description,
      this.lastModified,
      this.location,
      this.sequence,
      this.status,
      this.summary,
      this.transp,
      this.recurrenceId});

  Vevent.fromJson(Map<String, dynamic> json) {
    List<dynamic> l = new List<dynamic>();
    if (json['dtstart'] != null &&
        json['dtstart'].runtimeType == l.runtimeType) {
      String stamp = (json['dtstart'])[0];
      dtstart = DateTime(
          int.parse(stamp.substring(0, 4)),
          int.parse(stamp.substring(4, 6)),
          int.parse(stamp.substring(6, 8)),
          int.parse(stamp.substring(9, 11)),
          int.parse(stamp.substring(11, 13)),
          int.parse(stamp.substring(13, 15)));
    } else {
      String stamp = json['dtstart'];
      dtstart = DateTime(
          int.parse(stamp.substring(0, 4)),
          int.parse(stamp.substring(4, 6)),
          int.parse(stamp.substring(6, 8)),
          int.parse(stamp.substring(9, 11)),
          int.parse(stamp.substring(11, 13)),
          int.parse(stamp.substring(13, 15)));
    }

    if (json['dtend'] != null && json['dtend'].runtimeType == l.runtimeType) {
      String stamp = json['dtend'][0];
      dtend = DateTime(
          int.parse(stamp.substring(0, 4)),
          int.parse(stamp.substring(4, 6)),
          int.parse(stamp.substring(6, 8)),
          int.parse(stamp.substring(9, 11)),
          int.parse(stamp.substring(11, 13)),
          int.parse(stamp.substring(13, 15)));
    } else {
      String stamp = json['dtend'];
      dtend = DateTime(
          int.parse(stamp.substring(0, 4)),
          int.parse(stamp.substring(4, 6)),
          int.parse(stamp.substring(6, 8)),
          int.parse(stamp.substring(9, 11)),
          int.parse(stamp.substring(11, 13)),
          int.parse(stamp.substring(13, 15)));
    }
    rrule = json['rrule'] != null ? new Rrule.fromJson(json['rrule']) : null;
    dtstamp = json['dtstamp'];
    uid = json['uid'];
    attendee = json['attendee'];
    created = json['created'];
    description = json['description'];
    lastModified = json['last-modified'];
    location = json['location'];
    sequence = json['sequence'];
    status = json['status'];
    summary = json['summary'];
    transp = json['transp'];
    recurrenceId = json['recurrence-id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.rrule != null) {
      data['rrule'] = this.rrule.toJson();
    }
    data['dtstamp'] = this.dtstamp;
    data['uid'] = this.uid;
    data['attendee'] = this.attendee;
    data['created'] = this.created;
    data['description'] = this.description;
    data['last-modified'] = this.lastModified;
    data['location'] = this.location;
    data['sequence'] = this.sequence;
    data['status'] = this.status;
    data['summary'] = this.summary;
    data['transp'] = this.transp;
    data['recurrence-id'] = this.recurrenceId;
    return data;
  }
}
