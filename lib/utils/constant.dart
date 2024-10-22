import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var heightSpace = const SizedBox(
  height: 10,
);
var widthSpace = const SizedBox(
  width: 10,
);

int timeDuration = 30;
int page = 1;
int limit = 20;

SharedPreferences? prefs;

// Color
Color whiteColor = Colors.white;
// Color primaryColor = const Color(0xff00A397);
Color primaryColor = const Color(0xff5548B1);
Color scaffoldBodyColor = const Color(0xffEAFFFD);
Color inActiveColor = const Color(0xffFF0000);
Color dividerLineColor = const Color(0xffD9D9D9);
Color blackColor = const Color(0xff000000);
Color calenderScColor = const Color(0xffE0F8F6);
Color calenderPcColor = const Color(0xff00A397);
