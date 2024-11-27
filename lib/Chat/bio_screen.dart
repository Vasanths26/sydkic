import 'package:flutter/material.dart';
import 'package:sydkic/utils/constant.dart';

import '../utils/small_text.dart';
import '../utils/string.dart';

class BioScreen extends StatefulWidget {
  const BioScreen({super.key});

  @override
  State<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends State<BioScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: Container(
        // height: 294,
        // width: 343,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            details(Icons.email, 'Mail', 'praveenkumara@gmail.com'),
            const SizedBox(height: 20),
            details(Icons.smart_toy, 'Active Assistant', 'Professional Chat'),
            const SizedBox(height: 20),
            details(Icons.flag, 'Nation', 'India'),
            const SizedBox(height: 20),
            details(Icons.access_time_filled, 'Time', '03:00 PM'),
            const SizedBox(height: 20),
            details(Icons.work, 'Business', 'Empty'),
            const SizedBox(height: 20),
            details(Icons.person, 'Job Title', 'Empty'),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 15),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: biodividerColor,
                ),
              ),
            ),
            SmallText(
              text: 'Tags',
              size: 13,
              color: primaryColor,
              fontWeight: FontWeight.w500,
              fontFamily: MyStrings.outfit,
            ),
            const SizedBox(height: 13),
            Container(
              padding: const EdgeInsets.all(15),
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: appointmentConColor,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 2),
                            height: 20,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Add tags...',
                                hintStyle: TextStyle(
                                  color: appointmentText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: MyStrings.outfit,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 20,
                          width: 20,
                          // padding: const EdgeInsets.all(5),
                          // margin: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: primaryColor,
                          ),
                          child: Center(
                            child: Icon(Icons.add_circle_outline,
                                size: 12, color: whiteColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        height: 30,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: whiteColor,
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              SmallText(
                                text: 'Interested',
                                color: primaryColor,
                                size: 10,
                                fontWeight: FontWeight.w500,
                                fontFamily: MyStrings.outfit,
                              ),
                              const SizedBox(height: 2),
                              Icon(Icons.cancel, size: 18, color: primaryColor)
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        height: 30,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: whiteColor,
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              SmallText(
                                text: 'Interested',
                                color: primaryColor,
                                size: 10,
                                fontWeight: FontWeight.w500,
                                fontFamily: MyStrings.outfit,
                              ),
                              const SizedBox(height: 2),
                              Icon(Icons.cancel, size: 18, color: primaryColor)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget details(IconData icons, String text, String text2) {
    return SizedBox(
      // height: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Icon(icons, color: primaryColor),
          ),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(top: 1, bottom: 1),
            child: SizedBox(
              // height: 18,
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: MyStrings.outfit,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: secondaryColor,
                ),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            // height: 18,
            child: Text(
              text2,
              style: TextStyle(
                fontFamily: MyStrings.outfit,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: homeTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
