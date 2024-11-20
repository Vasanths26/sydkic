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
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000000),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
              height: 120,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: commonColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 46,
                    padding: const EdgeInsets.only(left: 20, right: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: blackColor.withOpacity(0.5),
                      border: Border.all(color: primaryColor, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(5, 5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: primaryColor, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _controller,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: MyStrings.outfit,
                              color: whiteColor,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search Name, Number, IG',
                              hintStyle: TextStyle(
                                color: homeTextColor,
                                fontFamily: MyStrings.outfit,
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 32,
                          width: 32,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                whiteColor.withOpacity(1),
                                primaryColor.withOpacity(1),
                              ],
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'asset/image/round_profile.webp',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap:
                    true, // Allows ListView to take only the required space
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
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: GradientBoxBorder(
                          width: 1,
                          gradient: LinearGradient(
                            colors: [
                              primaryColor, // #5548B1 at 30% opacity
                              primaryColor
                                  .withOpacity(0.3), // #5548B1 at 30% opacity
                            ], // Defines the distribution of colors
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                        color: liteGrey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.all(18),
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
                                      color: homeTextColor,
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
                                      color: primaryColor,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Created at : November 07, 2024',
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
                                child: Text(
                                  switchStates[index] ? 'Active' : 'Hold',
                                  style: TextStyle(
                                    color: switchStates[index]
                                        ? activeColor
                                        : holdColor,
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
                                    color: activeDeviceTextColor,
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
                                    inactiveTrackColor: whitecolor,
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
                }),
          ],
        ),
      ),
    );
  }
}
