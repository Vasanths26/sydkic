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
    return Container(
      height: 88,
      // width: 353,
      margin: const EdgeInsets.only(top: 25, left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xff242824),
      ),
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            // height: 18,
            // width: 95,
            child: Text(
              'Appointment',
              style: TextStyle(
                color: Color(0xff8B8E8C),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: MyStrings.outfit,
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 18,
            // width: 250,
            child: Text(
              'Full Body Checkup on 2024-08-12 | 9:00am',
              style: TextStyle(
                  color: whiteColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontFamily: MyStrings.outfit),
            ),
          ),
        ],
      ),
    );
  }
}
