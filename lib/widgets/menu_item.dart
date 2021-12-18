import 'package:flutter/material.dart';
import 'package:minimalarm/utils/colors.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const MenuItem({
    Key? key,
    required this.title,
    this.subtitle,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w300,
                fontSize: 12.0,
              ),
            )
          : null,
      trailing: trailing,
    );
  }
}
