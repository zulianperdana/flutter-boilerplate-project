import 'dart:convert';

import 'package:flutter/material.dart';

///parser service
const List<String> months = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember'
];

const List<String> monthsShort = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Ags',
  'Sep',
  'Okt',
  'Nov',
  'Des'
];

int parseInt(dynamic value) {
  try {
    if (!value.toString().contains('.')) {
      return value == 'null' || value == null ? 0 : int.parse(value.toString());
    } else {
      return parseDoubleInt(value);
    }
  } catch (e) {
    return parseDoubleInt(value);
  }
}

String timeOfDayToStringJson(TimeOfDay t) {
  return t.hour.toString() + ':' + t.minute.toString();
}

TimeOfDay stringToTimeOfDay(String s) {
  final List<String> splitted = s.split(':');
  return TimeOfDay(hour: parseInt(splitted[0]), minute: parseInt(splitted[1]));
}

double parseDouble(dynamic value) {
  return value == 'null' || value == null ? 0 : double.parse(value.toString());
}

Duration utcDiff;

Duration diffFromUtc() {
  if (utcDiff == null) {
    final DateTime utc = DateTime.now().toUtc();
    final DateTime dUtc = DateTime(utc.year, utc.month, utc.day, utc.hour, utc.minute,
        utc.second, utc.millisecond, utc.microsecond);
    utcDiff = DateTime.now().difference(dUtc);
  }
  return utcDiff;
}

int parseDoubleInt(dynamic value) {
  return parseDouble(value).toInt();
}

String parseString(dynamic value) {
  return value == 'null' || value == null ? '' : value.toString();
}

DateTime parseDateTime(dynamic value) {
  if (value is DateTime) {
    return value;
  }
  return value == null || value == 'null'
      ? DateTime.now()
      : DateTime.fromMillisecondsSinceEpoch(parseInt(value));
}

String durationToString(Duration duration){
  final int hours = duration.inHours.abs();
  if(hours > 24){
    final int days = duration.inDays.abs();
    final String dayIdentifier = days == 1 ? 'day' : 'days';
    return '$days $dayIdentifier';
  }
  final String hourIdentifier = hours == 1 ? 'hour' : 'hours';
  return '$hours $hourIdentifier';
}

int dateTimeToJson(dynamic value) {
  return value == null || value == 'null'
      ? DateTime.now().millisecondsSinceEpoch
      : value.millisecondsSinceEpoch;
}

DateTime parseDateTimeText(dynamic value) {
  return value == null || value == 'null'
      ? DateTime.now()
      : DateTime.parse(value).toLocal();
}

bool parseBool(dynamic value) {
  if (value is bool) {
    return value;
  }
  return value == null || value == null
      ? false
      : value.toString() == '1' || value.toString().toLowerCase() == 'true'
          ? true
          : false;
}

DateTime getDateOnly(DateTime date){
  return DateTime(date.year,date.month,date.day);
}

Map<String,List<T>> stringMapToList<T>(String string, T Function(dynamic) fromJson){
  if(string == null){
    return Map<String,List<T>>();
  }
  final Map<String, dynamic> mapDynamic = jsonDecode(string);
  final Map<String, List<T>> result = mapDynamic.map((k,i) => MapEntry(k, i.map<T>((c) => fromJson(c)).toList()));
  return result;
}

Map<String,dynamic> encodeIfString(dynamic d){
  if(d is String){
    return jsonDecode(d);
  }
  return d;
}

Map<String,T> stringMapToObject<T>(String string, T Function(dynamic) fromJson){
  if(string == null){
    return Map<String,T>();
  }
  final Map<String, dynamic> mapDynamic = jsonDecode(string);
  final Map<String, T> result = mapDynamic.map((k,i) => MapEntry(k, fromJson(i)));
  return result;
}

List<T> stringToList<T>(String string, T Function(dynamic) fromJson) {
  print('string to map success');
  return string == 'null' || string == null
      ? <T>[]
      : (jsonDecode(string) as List<dynamic>).map((dynamic e) => fromJson(e)).toList();
}

T stringToObject<T>(String string, T Function(dynamic) fromJson, dynamic def) {
  print('string to map success');
  return string == 'null' || string == null
      ? def
      : fromJson(jsonDecode(string));
}

List<T> stringToListNoDecode<T>(dynamic string, T Function(dynamic) fromJson) {
  print('string to map success');
  if(string is String){
    string = jsonDecode(string);
  }
  return string == 'null' || string == null
      ? <T>[]
      : (string as List<dynamic>).map((dynamic e) => fromJson(e)).toList();
}

T stringToObjectNoDecode<T>(
    dynamic string, T Function(dynamic) fromJson, dynamic def) {
  print('string to map success');
  return string == 'null' || string == null ? def : fromJson(string);
}

String addLeadingZero(String text) {
  if (text.length == 1) {
    return '0' + text;
  }
  return text;
}

String dateTimeToDateString(DateTime time) {
  if (time == null) {
    return '';
  }
  final String date = addLeadingZero(time.day.toString());
  final String month = months[time.month - 1];
  final String year = time.year.toString();
  return date + ' ' + month + ' ' + year;
}

String dateTimeToDateStringShort(DateTime time) {
  if (time == null) {
    return '';
  }
  final String date = addLeadingZero(time.day.toString());
  final String month = monthsShort[time.month - 1];
  return date + ' ' + month;
}

String dateTimeToDateStringShortEn(DateTime time) {
  if (time == null) {
    return '';
  }
  final String date = addLeadingZero(time.day.toString());
  final String month = monthsShort[time.month - 1];
  return month + ' ' + date;
}

String dateTimeToHour(DateTime time) {
  if (time == null) {
    return '';
  }
  final String hour = addLeadingZero(time.hour.toString());
  final String minute = addLeadingZero(time.minute.toString());
  return hour + '.' + minute;
}

String dateTimeToShortDate(DateTime time) {
  final String day = addLeadingZero(time.day.toString());
  final String month = addLeadingZero(time.month.toString());
  return month + '/' + day;
}

String dateTimeToShortDateYear(DateTime time) {
  if (time == null) {
    return '';
  }
  final String day = addLeadingZero(time.day.toString());
  final String month = addLeadingZero(time.month.toString());
  return month + '/' + day + '/' + time.year.toString();
}

String timeOfDayToString(TimeOfDay timeOfday) {
  return addLeadingZero(timeOfday.hour.toString()) +
      ':' +
      addLeadingZero(timeOfday.minute.toString());
}
