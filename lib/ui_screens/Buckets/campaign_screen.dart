import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

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

  List<String> text = [
    'Website Marketing',
    'Business Idea',
    'Test 01',
    'Test 02'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000000),
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(144),
      //   child: Container(
      //     height: 144,
      //     decoration: const BoxDecoration(
      //       image: DecorationImage(
      //         image: AssetImage('asset/image/image.png'),
      //         fit: BoxFit.cover,
      //       ),
      //       borderRadius: BorderRadius.only(
      //         bottomLeft: Radius.circular(12),
      //         bottomRight: Radius.circular(12),
      //       ),
      //     ),
      //     padding: const EdgeInsets.only(left: 20, top: 68, bottom: 20),
      //     child: Container(
      //       height: 46,
      //       margin: const EdgeInsets.only(right: 20),
      //       padding: const EdgeInsets.only(
      //         left: 20,
      //         right: 7,
      //       ),
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(28),
      //         color: const Color(0xff000000).withOpacity(0.5),
      //         border: Border.all(color: primaryColor, width: 1),
      //         boxShadow: [
      //           BoxShadow(
      //               color: Colors.black.withOpacity(0.3), // Light black shadow
      //               offset: const Offset(
      //                   5, 5), // Horizontal and vertical shadow position
      //               blurRadius: 10,
      //               spreadRadius: 0 // Spread radius
      //               ),
      //         ],
      //       ),
      //       child: Row(
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.only(top: 14, bottom: 14),
      //             child: Icon(Icons.search, color: primaryColor, size: 18),
      //           ),
      //           const SizedBox(width: 10),
      //           Expanded(
      //             child: Padding(
      //               padding: const EdgeInsets.only(top: 13.5, bottom: 13.5),
      //               child: TextFormField(
      //                 controller: _controller,
      //                 keyboardType: TextInputType.multiline,
      //                 style: TextStyle(
      //                   fontSize: 12,
      //                   fontWeight: FontWeight.w400,
      //                   fontFamily: MyStrings.outfit,
      //                   color: whiteColor,
      //                 ),
      //                 decoration: InputDecoration(
      //                   border: InputBorder.none,
      //                   hintText: 'Search Name, Number, IG',
      //                   hintStyle: TextStyle(
      //                     color: homeTextColor,
      //                     fontFamily: MyStrings.outfit,
      //                     fontWeight: FontWeight.w400,
      //                     fontSize: 13,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Container(
      //             height: 32,
      //             width: 32,
      //             padding: const EdgeInsets.all(2),
      //             decoration: BoxDecoration(
      //               shape: BoxShape.circle,
      //               gradient: LinearGradient(
      //                 colors: [
      //                   whiteColor.withOpacity(1),
      //                   primaryColor.withOpacity(1),
      //                 ],
      //               ),
      //             ),
      //             child: ClipOval(
      //               child: Image.asset(
      //                 'asset/image/round_profile.webp',
      //                 fit: BoxFit.cover,
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ListView.builder(
          shrinkWrap: true, // Allows ListView to take only the required space
          physics:
              const NeverScrollableScrollPhysics(), // Prevents inner scroll
          itemCount: text.length,
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
                height: 108,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: chineseBlack,
                  border: GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: [
                        primaryColor.withOpacity(1),
                        primaryColor.withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: EdgeInsets.only(
                    left: 20, right: 20, bottom: index == 3 ? 0 : 15),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          height: 23,
                          child: Text(
                            text[index],
                            style: TextStyle(
                                fontSize: 16,
                                color: homeTextColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: MyStrings.outfit),
                          ),
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          height: 18,
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                color: primaryColor,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'November 07, 2024',
                                style: TextStyle(
                                    color: secondaryColor,
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
                                  ? lightGreen
                                  : lightYellow,
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
                          // decoration: BoxDecoration(
                          //   border: Border.all(
                          //     color: paleLavendar,
                          //     width: 1.0,
                          //   ),
                          //   borderRadius: BorderRadius.circular(20.0),
                          // ),
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
                              trackOutlineColor:
                                  WidgetStatePropertyAll(Colors.transparent),
                              inactiveTrackColor: whiteColor,
                              inactiveThumbColor: primaryColor,
                              activeTrackColor: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
