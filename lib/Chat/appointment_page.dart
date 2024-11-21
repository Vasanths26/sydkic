import 'package:flutter/material.dart';
import 'package:sydkic/utils/constant.dart';
import '../utils/string.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 88,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xff242824), // Inner container color
          ),
          padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appointment',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: MyStrings.outfit,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Full Body Checkup on 2024-08-12 | 9:00am',
                style: TextStyle(
                  color: homeTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontFamily: MyStrings.outfit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
