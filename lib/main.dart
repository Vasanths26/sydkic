import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sydkic/ui_screens/appointment_screen.dart';
import 'package:sydkic/ui_screens/contact_assitent.dart';
import 'package:sydkic/ui_screens/contact_list_screen.dart';
import 'package:sydkic/ui_screens/Home/home_screen.dart';
import 'package:sydkic/ui_screens/inbox_screen.dart';
import 'package:sydkic/ui_screens/splash_screen.dart';
import 'package:sydkic/ui_screens/sms_screen.dart';
import 'package:sydkic/widget/bottom_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ScheduledProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ContactProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WebChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MessageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomePageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppointmentProvider(),
        ),
      ],
      child: const MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: FadeInAndSlide(),
      ),
    );
  }
}
