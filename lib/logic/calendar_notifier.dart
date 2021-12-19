import 'package:device_calendar/device_calendar.dart';
import 'package:either_option/either_option.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarNotifier extends StateNotifier<CalendarState> {
  final DeviceCalendarPlugin _calendarPlugin;

  CalendarNotifier(this._calendarPlugin) : super(CalendarState.initial());

  void init() async {
    var prefs = await SharedPreferences.getInstance();
    var isEnabled = prefs.getBool("calendar");
    isEnabled = isEnabled ?? false;
    if (!isEnabled) return;

    // calendar setting is enabled
    var result = await _calendarPlugin.hasPermissions();
    var permissions = result.data ?? false;
    if (!permissions) {
      result = await _calendarPlugin.requestPermissions();
      permissions = result.data ?? false;
      if (!permissions) {
        isEnabled = false;
      }
    }
    state = state.copyWith(calendarSetting: isEnabled);
    if (!isEnabled) return;

    // calendar setting is still enabled (user has grant permissions)
    var calId = prefs.getString("calendarId");
    if (calId == null) return;

    state = state.copyWith(calId: Some(calId));
    var now = DateTime.now();
    final dayAfterTomorrow = DateTime(now.year, now.month, now.day + 2);
    var res = await _calendarPlugin.retrieveEvents(
        calId, RetrieveEventsParams(startDate: now, endDate: dayAfterTomorrow));
    if (res.data == null) return;
    var events = res.data!;

    if (events.isNotEmpty) {
      state = state.copyWith(nextEvent: Some(events[0]));
    }
  }

  void changeSetting() async {
    var newValue = !state.calendarSetting;
    state = state.copyWith(calendarSetting: newValue);
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool("calendar", newValue);
    if (newValue == true) {
      init();
    } else {
      state = state.copyWith(calId: None(), nextEvent: None());
      prefs.remove("calendarId");
    }
  }

  void changeCalendar(String newCalId) async {
    state = state.copyWith(calId: Some(newCalId));
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("calendarId", newCalId);
    init();
  }
}

class CalendarState {
  final bool calendarSetting;
  final Option<String> calId;
  final Option<Event> nextEvent;

  CalendarState({
    required this.calendarSetting,
    required this.calId,
    required this.nextEvent,
  });

  factory CalendarState.initial() => CalendarState(
        calendarSetting: false,
        calId: None(),
        nextEvent: None(),
      );

  CalendarState copyWith({
    bool? calendarSetting,
    Option<String>? calId,
    Option<Event>? nextEvent,
  }) {
    return CalendarState(
      calendarSetting: calendarSetting ?? this.calendarSetting,
      calId: calId ?? this.calId,
      nextEvent: nextEvent ?? this.nextEvent,
    );
  }
}
