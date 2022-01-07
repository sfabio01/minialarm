import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/helpers/show_time_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalarm/logic/calendar_notifier.dart';
import 'package:minimalarm/logic/time_notifier.dart';
import 'package:minimalarm/pages/settings_menu.dart';
import 'package:minimalarm/utils/colors.dart';
import 'package:minimalarm/utils/utils.dart';
import 'package:minimalarm/widgets/event_card.dart';
import 'package:minimalarm/widgets/my_icon_button.dart';

var timeProvider = StateNotifierProvider<TimeNotifier, TimeState>(
    (ref) => TimeNotifier()..init());

var calendarProvider = StateNotifierProvider<CalendarNotifier, CalendarState>(
    (ref) => CalendarNotifier(DeviceCalendarPlugin())..init());

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      drawer: const Drawer(
        child: SettingsMenu(),
      ),
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              ref.watch(timeProvider).generateComment(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            ref.watch(timeProvider).time.fold(
                  () => MyIconButton(
                      icon: Icons.add_rounded,
                      onpress: () async {
                        var time = await showMaterialTimePicker(
                          context: context,
                          selectedTime: TimeOfDay.now(),
                          title: "SELECT TIME",
                        );
                        if (time != null) {
                          ref.read(timeProvider.notifier).changeTime(time);
                        }
                      }),
                  (time) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            ref.watch(settingsProvider).format24
                                ? time.hour.toString()
                                : from24to12format(time.hour).toString(),
                            style: TextStyle(
                              fontSize: 144,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            time.minute.toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: 96,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MyIconButton(
                              icon: Icons.delete_rounded,
                              onpress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: primaryColorDark,
                                    title: Text(
                                      "Confirm",
                                      style: TextStyle(color: textColor),
                                    ),
                                    content: Text(
                                      "Are you sure to remove the alarm?",
                                      style: TextStyle(color: textColor),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          "NO",
                                          style:
                                              TextStyle(color: secondaryColor),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          "YES",
                                          style:
                                              TextStyle(color: secondaryColor),
                                        ),
                                        onPressed: () {
                                          ref
                                              .read(timeProvider.notifier)
                                              .removeTime();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          MyIconButton(
                            icon: Icons.edit_rounded,
                            onpress: () async {
                              var time = await showMaterialTimePicker(
                                context: context,
                                selectedTime: TimeOfDay.now(),
                                title: "SELECT TIME",
                              );
                              if (time != null) {
                                ref
                                    .read(timeProvider.notifier)
                                    .changeTime(time);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            if (ref.watch(calendarProvider).calendarSetting)
              Column(
                children: const [
                  SizedBox(height: 50),
                  EventCard(),
                ],
              )
          ],
        ),
      ),
    );
  }
}
