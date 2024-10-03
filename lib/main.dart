import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sydkic/ui_screens/contact_assitent.dart';
import 'package:sydkic/ui_screens/contact_list_screen.dart';
import 'package:sydkic/ui_screens/sign_in_screen.dart';
import 'package:sydkic/ui_screens/sms_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(
          create: (_) => ScheduledProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ContactProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MessageProvider(),
        ),
      ],
      child: const MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: SignInScreen(),
      ),
    );
  }
}

