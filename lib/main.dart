import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimalarm/pages/home_page.dart';
import 'package:minimalarm/utils/colors.dart';
import 'package:minimalarm/utils/values.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'minimALARM',
      theme: ThemeData(
        textTheme: GoogleFonts.ralewayTextTheme(),
        colorScheme: ColorScheme.dark(
          primary: primaryColor,
          onPrimary: textColor,
          primaryVariant: primaryColorDark,
          secondary: secondaryColor,
          background: primaryColor,
          onBackground: textColor,
          onSecondary: textColor,
        ),
        timePickerTheme: TimePickerThemeData(
          dialHandColor: secondaryColor,
          dayPeriodBorderSide: BorderSide.none,
          dayPeriodTextColor: textColor,
          hourMinuteTextColor: textColor,
          helpTextStyle: TextStyle(color: textColor, fontSize: 11.0),
        ),
      ),
      home: const HomePage(),
    );
  }
}
