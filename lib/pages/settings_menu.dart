import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalarm/logic/settings_notifier.dart';
import 'package:minimalarm/models/custom_map_entry.dart';
import 'package:minimalarm/pages/home_page.dart';
import 'package:minimalarm/utils/colors.dart';
import 'package:minimalarm/utils/values.dart';
import 'package:minimalarm/widgets/menu_item.dart';

var settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
    (ref) => SettingsNotifier()..init());

class SettingsMenu extends ConsumerStatefulWidget {
  const SettingsMenu({Key? key}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 16.0),
        color: primaryColorDark,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SETTINGS",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.menu_open_rounded,
                      color: textColor,
                      size: 36,
                    ),
                  ),
                ],
              ),
              ListView(
                shrinkWrap: true,
                children: [
                  MenuItem(
                    title: "NOTIFICATIONS",
                    subtitle: "REMIND ME TO SET THE ALARM",
                    trailing: Switch(
                      activeColor: accentColor,
                      value: ref.watch(settingsProvider).notifications,
                      onChanged: (newValue) {
                        ref
                            .read(settingsProvider.notifier)
                            .changeValue("notifications", newValue);
                      },
                    ),
                  ),
                  MenuItem(
                    title: "CALENDAR",
                    subtitle:
                        "CONNECT YOUR CALENDAR TO MAKE SURE YOU DON’T MISS ANY EVENT",
                    trailing: Switch(
                      activeColor: accentColor,
                      value: ref.watch(calendarProvider).calendarSetting,
                      onChanged: (newValue) {
                        ref.read(calendarProvider.notifier).changeSetting();
                      },
                    ),
                  ),
                  MenuItem(
                    title: "24 HOUR FORMAT",
                    trailing: Switch(
                      activeColor: accentColor,
                      value: ref.watch(settingsProvider).format24,
                      onChanged: (newValue) {
                        ref
                            .read(settingsProvider.notifier)
                            .changeValue("format24", newValue);
                      },
                    ),
                  ),
                  Divider(color: textColor),
                  MenuItem(
                    title: "SOUND",
                    subtitle:
                        ref.watch(settingsProvider).sound.value.toUpperCase(),
                    trailing: TextButton(
                      onPressed: () async {
                        var platform = const MethodChannel(channel);
                        var res = await platform.invokeMethod<
                            LinkedHashMap<Object?, Object?>>("getSounds");
                        var sounds = res!.entries
                            .map((e) => CustomMapEntry(
                                e.key.toString(), e.value.toString()))
                            .toList();
                        sounds.insert(
                            0, const CustomMapEntry("default", "default"));
                        var selectedSound =
                            await showMaterialScrollPicker<CustomMapEntry>(
                          context: context,
                          items: sounds,
                          selectedItem: ref.watch(settingsProvider).sound,
                          showDivider: false,
                          title: "SELECT A SOUND",
                          backgroundColor: primaryColorDark,
                          buttonTextColor: secondaryColor,
                          transformer: (item) => item.value.toUpperCase(),
                        );
                        if (selectedSound != null) {
                          ref
                              .read(settingsProvider.notifier)
                              .changeValue("sound", selectedSound);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Text(
                          "CHANGE",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  MenuItem(
                    title: "RING DURATION",
                    subtitle:
                        "${ref.watch(settingsProvider).ringDuration} MINUTES",
                    trailing: TextButton(
                      onPressed: () async {
                        var selected = await showMaterialNumberPicker(
                          context: context,
                          title: 'SELECT RING DURATION',
                          backgroundColor: primaryColorDark,
                          buttonTextColor: secondaryColor,
                          maxNumber: 5,
                          minNumber: 1,
                          selectedNumber:
                              ref.watch(settingsProvider).ringDuration,
                        );
                        if (selected != null) {
                          ref
                              .read(settingsProvider.notifier)
                              .changeValue("ringDuration", selected);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Text(
                          "CHANGE",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  MenuItem(
                    title: "VIBRATE",
                    trailing: Switch(
                      activeColor: accentColor,
                      value: ref.watch(settingsProvider).vibrate,
                      onChanged: (newValue) {
                        ref
                            .read(settingsProvider.notifier)
                            .changeValue("vibrate", newValue);
                      },
                    ),
                  ),
                  Divider(color: textColor),
                  const MenuItem(title: "CREDITS"),
                  const MenuItem(
                    title: "BUY ME A COFFEE",
                    trailing: Icon(Icons.launch_rounded),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
