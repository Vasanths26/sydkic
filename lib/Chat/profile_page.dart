import 'package:flutter/material.dart';

import '../utils/constant.dart';
import '../utils/string.dart';

class PersonProfile extends StatefulWidget {
  const PersonProfile({super.key});

  @override
  State<PersonProfile> createState() => _PersonProfileState();
}

class _PersonProfileState extends State<PersonProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121212),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back, size: 20, color: whiteColor),
                  ),
                ),
                const SizedBox(width: 22),
                Container(
                  alignment: Alignment.center,
                  height: 24.78,
                  // width: 59,
                  child: Text(
                    'Profile',
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: MyStrings.outfit),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.22),
            Container(
              height: 103,
              width: 343,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xff242824),
              ),
              padding: const EdgeInsets.fromLTRB(25, 25, 0, 25),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: ClipOval(
                      child: Image.asset(
                        'asset/image/round_profile.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        // height: 18,
                        // width: 108,
                        child: Text(
                          'Dianne Russell',
                          style: TextStyle(
                            fontFamily: MyStrings.outfit,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffFFFFFF),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 18,
                        // width: 61,
                        child: Text(
                          '7418601714',
                          style: TextStyle(
                            fontFamily: MyStrings.outfit,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff8B8E8C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 58,
              width: 343,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Text(
                    'Auto Replay',
                    style: TextStyle(
                      fontFamily: MyStrings.outfit,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: blackColor,
                    ),
                  ),
                  const Spacer(),
                  Transform.scale(
                    scale: 0.75,
                    child: Switch(
                      value: false,
                      onChanged: (value) {},
                      inactiveTrackColor: const Color(0xffF0F2F5),
                      inactiveThumbColor: const Color(0xff121212),
                      trackOutlineWidth:
                          WidgetStateProperty.resolveWith<double?>(
                              (Set<WidgetState> states) {
                        return 1;
                      }),
                      trackOutlineColor:
                          WidgetStateProperty.resolveWith<Color?>(
                              (Set<WidgetState> states) {
                        return const Color(0xff8B8E8C);
                      }),
                      activeTrackColor: const Color(0xff121212),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              // height: 294,
              width: 343,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  details(
                      Icons.email_outlined, 'Mail', 'praveenkumara@gmail.com'),
                  const SizedBox(height: 30),
                  details(Icons.smart_toy_outlined, 'Active Assistant',
                      'Professional Chat'),
                  const SizedBox(height: 30),
                  details(Icons.language_outlined, 'Nation', 'India'),
                  const SizedBox(height: 30),
                  details(Icons.access_time_outlined, 'Time', '03:00 PM'),
                  const SizedBox(height: 30),
                  details(Icons.work_outline, 'Empty', ''),
                  const SizedBox(height: 30),
                  details(Icons.person_outline, 'Empty', ''),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget details(IconData icons, String text, String text2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Icon(icons, color: whiteColor),
        ),
        const SizedBox(width: 12),
        SizedBox(
          // height: 18,
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: MyStrings.outfit,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xff8B8E8C),
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
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: whiteColor,
            ),
          ),
        ),
      ],
    );
  }
}
