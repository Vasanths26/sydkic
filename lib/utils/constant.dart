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
Color signinorColor = const Color(0xffABBED1);
Color secondaryColor = const Color(0xff8B8E8C);
Color scaffoldBodyColor = const Color(0xffEAFFFD);
Color inActiveColor = const Color(0xffFF0000);
Color dividerLineColor = const Color(0xffD9D9D9);
Color blackColor = const Color(0xff000000);
Color calenderScColor = const Color(0xffE0F8F6);
Color calenderPcColor = const Color(0xff00A397);
Color backgroundcolor = const Color(0xff121212);
Color whitecolor = const Color(0xffFFFFFF);
Color liteGrey = const Color(0xff1A1C1A);
Color homeTextColor = const Color(0xff9490AE);
Color activeDeviceTextColor = const Color(0xffE0DCFF);
Color sellAllColor = const Color(0xffD9D3FF);
Color appointmentConColor = const Color(0xff141416);
Color commonColor = const Color(0xff302660);
Color assistantImageColor = const Color(0xff393939);
Color activeColor = const Color(0xff60D669);
Color holdColor = const Color(0xffFFD002);
Color appointmentText= const Color(0xff4B4B4B);
Color biodividerColor= const Color(0xff242824);


Color paleLavendar = const Color(0xffE0DCFF);//duplicate of activeDeviceTextColor
Color antiflashWhite = const Color(0xffF0F2F5);
Color onyxColor = const Color(0xff393939);//duplicate of assistantImageColor
Color onyxColor1 = const Color(0xff373737);
Color raisinBlack = const Color(0xff202020);
Color chineseBlack = const Color(0xff141416);//duplicate of appointmentConColor
Color lightGreen = const Color(0xff60D669);//duplicate of active color
Color lightYellow = const Color(0xffFFD002);//duplicate of hold color