import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalarm/pages/home_page.dart';
import 'package:minimalarm/utils/colors.dart';

class EventCard extends ConsumerWidget {
  const EventCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(calendarProvider).calId.fold(
      () => TextButton(
          onPressed: () async {
            var result = await DeviceCalendarPlugin().retrieveCalendars();
            var data = result.data!.toList();
            var selectedCal = await showMaterialRadioPicker<Calendar>(
              context: context,
              items: data,
              backgroundColor: primaryColorDark,
              transformer: (item) => item.name,
              title: "SELECT A CALENDAR",
              buttonTextColor: secondaryColor,
            );
            if (selectedCal != null) {
              ref
                  .read(calendarProvider.notifier)
                  .changeCalendar(selectedCal.id!);
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.black.withAlpha(50),
          ),
          child: Text(
            "Tap to choose a calendar",
            style: TextStyle(color: textColor),
          )),
      (_) {
        var event = ref.read(calendarProvider).nextEvent;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.black.withAlpha(50),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "NEXT EVENT",
                style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4.0),
              event.fold(
                () => Text(
                  "You have no planned events",
                  style: TextStyle(color: textColor),
                ),
                (ev) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ev.title!,
                      style: TextStyle(color: textColor),
                    ),
                    Text(
                      "${ev.start!.hour.toString()}:${ev.start!.minute.toString()} - ${ev.end!.hour.toString()}:${ev.end!.minute.toString()}",
                      style: TextStyle(
                          color: textColor, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
