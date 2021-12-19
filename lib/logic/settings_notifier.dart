import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState.initial());

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var notifications = prefs.getBool("notifications");
    var format24 = prefs.getBool("format24");
    var sound = prefs.getString("sound");
    var vibrate = prefs.getBool("vibrate");
    var ringDuration = prefs.getInt("ringDuration");

    state = state.copyWith(
      notifications: notifications ?? true,
      format24: format24 ?? false,
      sound: sound ?? "default",
      vibrate: vibrate ?? true,
      ringDuration: ringDuration ?? 5,
    );
  }

  void changeValue(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (key) {
      case "notifications":
        state = state.copyWith(notifications: value);
        prefs.setBool(key, value);
        break;
      case "format24":
        state = state.copyWith(format24: value);
        prefs.setBool(key, value);
        break;
      case "sound":
        state = state.copyWith(sound: value);
        prefs.setString(key, value);
        break;
      case "vibrate":
        state = state.copyWith(vibrate: value);
        prefs.setBool(key, value);
        break;
      case "ringDuration":
        state = state.copyWith(ringDuration: value);
        prefs.setInt(key, value);
        break;
    }
  }
}

class SettingsState {
  final bool notifications;
  final bool format24;
  final String sound;
  final int ringDuration;
  final bool vibrate;

  SettingsState({
    required this.notifications,
    required this.format24,
    required this.sound,
    required this.ringDuration,
    required this.vibrate,
  });

  factory SettingsState.initial() => SettingsState(
        notifications: true,
        format24: false,
        sound: "default",
        ringDuration: 5,
        vibrate: true,
      );

  SettingsState copyWith({
    bool? notifications,
    bool? format24,
    String? sound,
    int? ringDuration,
    bool? vibrate,
  }) {
    return SettingsState(
      notifications: notifications ?? this.notifications,
      format24: format24 ?? this.format24,
      sound: sound ?? this.sound,
      ringDuration: ringDuration ?? this.ringDuration,
      vibrate: vibrate ?? this.vibrate,
    );
  }
}
