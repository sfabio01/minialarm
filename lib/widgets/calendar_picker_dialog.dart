import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalarm/utils/colors.dart';

class CalendarPickerDialog extends ConsumerStatefulWidget {
  const CalendarPickerDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CalendarPickerDialogState();
}

class _CalendarPickerDialogState extends ConsumerState<CalendarPickerDialog> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchCalendars(),
        builder: (context, AsyncSnapshot<List<Calendar>> snap) {
          if (snap.hasData) {
            final calendars = snap.data!;
            return SimpleDialog(
                title: Text(
                  "Choose your favorite calendar",
                  style: TextStyle(color: textColor),
                ),
                children: [
                  ...calendars
                      .map<Widget>((cal) => Radio<String>(
                          value: cal.id!,
                          groupValue: "calendars",
                          onChanged: (id) {
                            setState(() {
                              _selected = id!;
                            });
                          }))
                      .toList(),
                  Row(
                    children: [
                      TextButton(
                        child: Text(
                          "OK",
                          style: TextStyle(color: textColor),
                        ),
                        onPressed: () {
                          // TODO
                        },
                      ),
                    ],
                  ),
                ]);
          }
          if (snap.hasError) {
            // TODO: show error toast
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Future<List<Calendar>> fetchCalendars() async {
    var result = await DeviceCalendarPlugin().retrieveCalendars();
    var data = result.data;
    return data!.toList();
  }
}
