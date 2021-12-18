import 'package:flutter/material.dart';

int compareTimes(TimeOfDay time1, TimeOfDay time2) {
  // Compares 2 times.
  // Return 0 if time1 = time2;
  // return 1 if time1 < time2;
  // return 2 if time1 > time2.

  if (time1.hour < time2.hour) {
    return 1;
  }
  if (time1.hour > time2.hour) {
    return 2;
  }
  if (time1.minute < time2.minute) {
    return 1;
  }
  if (time1.minute > time2.minute) {
    return 2;
  }
  return 0;
}

int from24to12format(int hour) {
  if (hour > 12) {
    hour = hour - 12;
  }
  if (hour == 0) {
    hour = 12;
  }
  return hour;
}
