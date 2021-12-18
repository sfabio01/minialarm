import 'package:flutter/material.dart';
import 'package:minimalarm/utils/colors.dart';

class MyIconButton extends StatelessWidget {
  final IconData icon;
  final void Function() onpress;

  const MyIconButton({Key? key, required this.icon, required this.onpress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onpress,
      child: Container(
        width: 65,
        height: 65,
        decoration:
            BoxDecoration(color: secondaryColor, shape: BoxShape.circle),
        child: Icon(
          icon,
          color: textColor,
          size: 36,
        ),
      ),
    );
  }
}
