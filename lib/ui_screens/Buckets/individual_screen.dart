import 'package:flutter/material.dart';

import '../../utils/constant.dart';
import '../../utils/string.dart';
import 'widgets/interested_page.dart';

class IndividualScreen extends StatefulWidget {
  const IndividualScreen({super.key});

  @override
  State<IndividualScreen> createState() => _IndividualScreenState();
}

class _IndividualScreenState extends State<IndividualScreen> {
  int selectedIndex = 0;
  bool isSwitchOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000000),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 42.86),
        child: Column(
          children: [
            Container(
              height: 25,
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3, bottom: 2),
                    child: Icon(Icons.arrow_back, size: 20, color: whiteColor),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    height: 25,
                    child: Text(
                      'Website Marketing',
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          fontFamily: MyStrings.outfit),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 18,
                    width: 32,
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffE0DCFF),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Transform.scale(
                      scale: 0.75,
                      child: Switch(
                        value: isSwitchOn,
                        onChanged: (value) {
                          setState(() {
                            value = false;
                            setState(() {
                              isSwitchOn = value; // Update the switch state
                            });
                          });
                        },
                        inactiveTrackColor: const Color(0xffFFFFFF),
                        inactiveThumbColor: const Color(0xff5548B1),
                        activeTrackColor: const Color(0xff5548B1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                topic('Interested', 0),
                const SizedBox(width: 15),
                topic('Budget Concern', 1),
                const SizedBox(width: 15),
                topic('Enquiring', 2),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                topic('Not Intersted - Currently No Need', 3),
                const SizedBox(width: 15),
                topic('Spam', 4),
              ],
            ),
            const SizedBox(height: 30),
            const InterestedPage(),
          ],
        ),
      ),
    );
  }

  Widget topic(String text, int index) {
    bool isSelected = selectedIndex == index;
    Color containerColor = isSelected ? Colors.white : const Color(0xff1A1C1A);
    Color textColor = isSelected ? Colors.black : Colors.white;

    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        // height: 26,
        // width: 79,
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: containerColor,
        ),
        child: Center(
          // height: 16,
          // // width: 59,
          child: Text(
            text,
            style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                fontFamily: MyStrings.outfit),
          ),
        ),
      ),
    );
  }
}
