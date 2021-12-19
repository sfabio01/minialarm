import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalarm/logic/settings_notifier.dart';
import 'package:minimalarm/pages/home_page.dart';
import 'package:minimalarm/utils/colors.dart';
import 'package:minimalarm/widgets/menu_item.dart';
import 'package:minimalarm/widgets/number_picker_dialog.dart';

var settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
    (ref) => SettingsNotifier()..init());

class SettingsMenu extends ConsumerWidget {
  const SettingsMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        color: primaryColorDark,
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
                  subtitle: ref.watch(settingsProvider).sound.toUpperCase(),
                  trailing: TextButton(
                    onPressed: () {},
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
                    onPressed: () {
                      showDialog<int>(
                        context: context,
                        builder: (BuildContext context) => NumberPickerDialog(
                            ref.read(settingsProvider).ringDuration),
                      );
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
    );
  }
}
