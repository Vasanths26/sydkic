import 'package:flutter/material.dart';

import '../utils/constant.dart';
import '../utils/string.dart';

class LeadHistory extends StatefulWidget {
  const LeadHistory({super.key});

  @override
  State<LeadHistory> createState() => _LeadHistoryState();
}

class _LeadHistoryState extends State<LeadHistory> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            steps(
                'Customer inquiring about appointment booking', '1', 16, 25.5),
            const SizedBox(height: 20),
            steps(
                'Successfully booked appointments for customer and customer\'s cousin',
                '2',
                32,
                33.5),
            const SizedBox(height: 20),
            steps(
                'Successfully booked appointments for customer and customer\'s cousin',
                '3',
                32,
                33.5),
            const SizedBox(height: 20),
            steps(
                'Successfully booked appointments for customer and customer\'s cousin',
                '4',
                32,
                33.5),
          ],
        ),
        Positioned(
          left: 33,
          top: 85,
          child: Container(
            height: 70,
            width: 4,
            // margin: const EdgeInsets.only(left: 13),
            decoration: BoxDecoration(
              color: const Color(0xff242824),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        Positioned(
          left: 33,
          top: 194,
          child: Container(
            height: 78,
            width: 4,
            // margin: const EdgeInsets.only(left: 13),
            decoration: BoxDecoration(
              color: const Color(0xff242824),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        Positioned(
          left: 33,
          top: 311,
          child: Container(
            height: 78,
            width: 4,
            // margin: const EdgeInsets.only(left: 13),
            decoration: BoxDecoration(
              color: const Color(0xff242824),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }

  Widget steps(String text, String text1, double height, double stick) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 30,
              width: 30,
              margin: EdgeInsets.only(left: 20, bottom: 5, top: stick),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff242824),
              ),
              child: Center(
                child: Text(
                  text1,
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: MyStrings.outfit),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Container(
              // height: 81,
              width: 315,
              // padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
                    decoration: BoxDecoration(
                      color: const Color(0xff242824),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height,
                          width: 290,
                          child: Text(
                            text,
                            style: TextStyle(
                                color: whiteColor,
                                height: 1.0,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                fontFamily: MyStrings.outfit),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 25,
                          width: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xff5548B1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'DISQUALIFIED',
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                fontFamily: MyStrings.outfit),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
