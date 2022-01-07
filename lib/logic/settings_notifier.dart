import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalarm/models/custom_map_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState.initial());

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var notifications = prefs.getBool("notifications");
    var format24 = prefs.getBool("format24");
    var temp = prefs.getString("sound");
    var sound = temp != null
        ? CustomMapEntry(temp.split("==")[0], temp.split("==")[1])
        : null;
    var vibrate = prefs.getBool("vibrate");
    var ringDuration = prefs.getInt("ringDuration");

    state = state.copyWith(
      notifications: notifications ?? true,
      format24: format24 ?? false,
      sound: sound ?? const CustomMapEntry("default", "default"),
      vibrate: vibrate ?? false,
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
        prefs.setString(key, "${value.key}==${value.value}");
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
  final CustomMapEntry sound;
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
        sound: const CustomMapEntry("default", "default"),
        ringDuration: 5,
        vibrate: false,
      );

  SettingsState copyWith({
    bool? notifications,
    bool? format24,
    CustomMapEntry? sound,
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SettingsState &&
        other.notifications == notifications &&
        other.format24 == format24 &&
        other.sound == sound &&
        other.ringDuration == ringDuration &&
        other.vibrate == vibrate;
  }

  @override
  int get hashCode {
    return notifications.hashCode ^
        format24.hashCode ^
        sound.hashCode ^
        ringDuration.hashCode ^
        vibrate.hashCode;
  }
}
