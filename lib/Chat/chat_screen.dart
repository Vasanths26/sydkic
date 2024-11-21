import 'package:flutter/material.dart';
import 'package:sydkic/Chat/bio_screen.dart';
import 'package:sydkic/utils/string.dart';
import '../utils/constant.dart';
import 'appointment_page.dart';
import 'chat_page.dart';
import 'lead_history.dart';
import 'note_page.dart';
import 'profile_page.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int selectedIndex = 0;

  // List of pages corresponding to tabs
  final List<Widget> pages = [
    const ChatPage(),
    const BioScreen(),
    const LeadHistory(),
    const AppointmentPage(),
    const NotePage(),
  ];

  // List of tab titles
  final List<String> tabTitles = [
    'Chat',
    'Bio',
    'Lead History',
    'Appointment',
    'Notes'
  ];

  // Toggle switch state
  bool switchState = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundcolor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0, // This will fix the problem
        automaticallyImplyLeading: false,
        backgroundColor: blackColor,
        toolbarHeight: 150,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back, color: whiteColor),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child: Image.asset(
                          'asset/image/round_profile.webp',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PersonProfile(),
                          ),
                        );
                      },
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dianne Russell',
                            style: TextStyle(
                              fontFamily: MyStrings.outfit,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffFFFFFF),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '7418601714',
                            style: TextStyle(
                              fontFamily: MyStrings.outfit,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff8B8E8C),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 18,
                      width: 40,
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
                          value: switchState,
                          onChanged: (value) {
                            setState(() {
                              switchState = value; // Update the switch state
                            });
                          },
                          inactiveTrackColor: whiteColor,
                          inactiveThumbColor: primaryColor,
                          activeTrackColor: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(tabTitles.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: topics(tabTitles[index], index),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double
                    .infinity, // Ensures the container spans the full width
                height: 1, // Sets the height of the divider line
                color: Color(0xff242824), // Line color (adjust as needed)
              ),
            ],
          ),
        ),
      ),
      body: pages[selectedIndex],
    );
  }

  Widget topics(String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: MyStrings.outfit,
              overflow: TextOverflow.ellipsis,
              fontSize: 13,
              fontWeight:
                  selectedIndex == index ? FontWeight.w600 : FontWeight.w400,
              color: selectedIndex == index ? primaryColor : homeTextColor,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 4,
            width: selectedIndex == index ? 10 : 0,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}
