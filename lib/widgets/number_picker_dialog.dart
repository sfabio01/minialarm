import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimalarm/pages/settings_menu.dart';
import 'package:minimalarm/utils/colors.dart';
import 'package:numberpicker/numberpicker.dart';

class NumberPickerDialog extends ConsumerStatefulWidget {
  final int initialValue;

  const NumberPickerDialog(this.initialValue, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NumberPickerDialogState();
}

class _NumberPickerDialogState extends ConsumerState<NumberPickerDialog> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      backgroundColor: primaryColorDark,
      title: Text(
        "RING DURATION",
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
      ),
      children: [
        NumberPicker(
          textStyle: TextStyle(color: textColor),
          minValue: 1,
          maxValue: 5,
          value: _currentValue,
          onChanged: (newValue) {
            setState(() {
              _currentValue = newValue;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text(
                "OK",
                style: TextStyle(color: textColor),
              ),
              onPressed: () {
                ref
                    .read(settingsProvider.notifier)
                    .changeValue("ringDuration", _currentValue);
                Navigator.of(context).pop();
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
      ],
    );
  }
}
