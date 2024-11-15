import 'package:flutter/material.dart';

import '../../utils/constant.dart';
import '../../utils/string.dart';
import 'individual_screen.dart';

class BucketScreen extends StatefulWidget {
  const BucketScreen({super.key});

  @override
  State<BucketScreen> createState() => _BucketScreenState();
}

class _BucketScreenState extends State<BucketScreen> {
  List<bool> switchStates = List.generate(10, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000000),
      body: ListView.builder(
          shrinkWrap: true, // Allows ListView to take only the required space
          physics:
              const NeverScrollableScrollPhysics(), // Prevents inner scroll
          itemCount: 4,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IndividualScreen(),
                  ),
                );
              },
              child: Container(
                height: 106,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: liteGrey,
                  borderRadius: BorderRadius.circular(5),
                ),
                margin:
                    const EdgeInsets.all(12),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          height: 20,
                          child: Text(
                            'Test 01',
                            style: TextStyle(
                                fontSize: 16,
                                color: whiteColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: MyStrings.outfit),
                          ),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          height: 18,
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: whiteColor,
                                size: 15,
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'Created at : November 07, 2024',
                                style: TextStyle(
                                    color: Color(0xff8B8E8C),
                                    fontSize: 13,
                                    fontFamily: MyStrings.outfit,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        SizedBox(
                          height: 16,
                          // width: 37,
                          child: Text(
                            switchStates[index] ? 'Active' : 'Hold',
                            style: TextStyle(
                              color: switchStates[index]
                                  ? const Color(0xff60D669)
                                  : const Color(0xffFFD002),
                              fontSize: 13,
                              fontFamily: MyStrings.outfit,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
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
                              value: switchStates[index],
                              onChanged: (value) {
                                setState(() {
                                  switchStates[index] =
                                      value; // Update the specific switch state
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
                  ],
                ),
              ),
            );
          }),
    );
  }
}
