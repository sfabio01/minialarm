import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalarm/pages/home_page.dart';
import 'package:minimalarm/utils/colors.dart';

class CalendarPickerDialog extends ConsumerStatefulWidget {
  const CalendarPickerDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CalendarPickerDialogState();
}

class _CalendarPickerDialogState extends ConsumerState<CalendarPickerDialog> {
  String _selected = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchCalendars(),
        builder: (context, AsyncSnapshot<List<Calendar>> snap) {
          if (snap.hasData) {
            final calendars = snap.data!;
            return SimpleDialog(
              backgroundColor: primaryColorDark,
              title: Text(
                "Choose your preferred calendar",
                style: TextStyle(color: textColor),
              ),
              children: [
                ...calendars
                    .map<Widget>((cal) => RadioListTile<String?>(
                          title: Text(
                            cal.name!,
                            style: TextStyle(color: textColor),
                          ),
                          groupValue: _selected,
                          value: cal.id!,
                          selected: cal.id! == _selected,
                          activeColor: accentColor,
                          onChanged: (value) {
                            setState(() {
                              _selected = value!;
                            });
                          },
                        ))
                    .toList(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          "OK",
                          style: TextStyle(color: textColor),
                        ),
                        onPressed: () {
                          if (_selected != "") {
                            ref
                                .read(calendarProvider.notifier)
                                .changeCalendar(_selected);
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      TextButton(
                        child: Text(
                          "CANCEL",
                          style: TextStyle(color: secondaryColor),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          if (snap.hasError) {
            // TODO: show error toast
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Future<List<Calendar>> _fetchCalendars() async {
    var result = await DeviceCalendarPlugin().retrieveCalendars();
    var data = result.data;
    return data!.toList();
  }
}
