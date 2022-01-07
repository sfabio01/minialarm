import 'package:either_option/either_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalarm/utils/utils.dart';
import 'package:minimalarm/utils/values.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeNotifier extends StateNotifier<TimeState> {
  final _platform = const MethodChannel(channel);
  TimeNotifier() : super(TimeState.initial());

  void init() async {
    var prefs = await SharedPreferences.getInstance();
    var hour = prefs.getInt("hour");
    var min = prefs.getInt("min");
    if (hour != null && min != null) {
      var time = TimeOfDay(hour: hour, minute: min);
      state = TimeState(Some(time));
    }
  }

  void changeTime(TimeOfDay newTime) async {
    try {
      var currentTime = TimeOfDay.now();
      var now = DateTime.now();
      var alarmTime =
          DateTime(now.year, now.month, now.day, newTime.hour, newTime.minute);
      if (compareTimes(newTime, currentTime) == 1) {
        // tomorrow
        alarmTime = alarmTime.add(const Duration(days: 1));
      }

      var res = await _platform.invokeMethod<String>(
          "setAlarm", alarmTime.millisecondsSinceEpoch);

      print("ANDROID: $res"); // debug

      var prefs = await SharedPreferences.getInstance();
      prefs.setInt("hour", newTime.hour);
      prefs.setInt("min", newTime.minute);
      state = TimeState(Some(newTime));
    } on MissingPluginException {
      print("Not implemented"); // debug
    } on PlatformException {
      print("Platform exception"); // debug
    }
  }

  void removeTime() async {
    var res = await _platform.invokeMethod<int>("cancelAlarm");
    if (res == 0) {
      var prefs = await SharedPreferences.getInstance();
      prefs.remove("hour");
      prefs.remove("min");
      state = TimeState.initial();
    } else {
      // TODO: handle error
    }
  }
}

class TimeState {
  Option<TimeOfDay> time;

  TimeState(this.time);

  factory TimeState.initial() => TimeState(None());

  String generateComment() => time.fold(
        () => "SET AN ALARM",
        (time) {
          var now = TimeOfDay.now();
          var comment = "";
          if (compareTimes(time, now) == 1) {
            if (time.hour < 4) {
              comment += "THIS ";
            } else {
              comment += "TOMORROW ";
            }
          } else {
            comment += "THIS ";
          }
          if (time.hour < 4) {
            comment += "NIGHT ";
          }
          if (time.hour >= 4 && time.hour < 12) {
            comment += "MORNING ";
          }
          if (time.hour >= 12 && time.hour < 18) {
            comment += "AFTERNOON ";
          }
          if (time.hour >= 18) {
            comment += "EVENING ";
          }
          comment += "AT";
          return comment;
        },
      );
}

void playAlarm() {}
