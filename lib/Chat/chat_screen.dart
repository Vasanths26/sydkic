import 'package:flutter/material.dart';
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
  bool isSelect = false;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xff000000),
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the default back arrow
        backgroundColor: const Color(0xff000000),
        toolbarHeight: 138,
        flexibleSpace: Padding(
          padding: const EdgeInsets.fromLTRB(20, 49.86, 20, 10),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back, color: whiteColor),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 40,
                    width: 40,
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
                        SizedBox(
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
                        SizedBox(height: 4),
                        SizedBox(
                          height: 18,
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
                  ),
                  const Spacer(),
                  Icon(Icons.more_vert, color: whiteColor),
                ],
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 23, left: 10, right: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                        });
                      },
                      child: topics('Chat', 29, 0),
                    ),
                    const SizedBox(width: 37.7),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },
                      child: topics('Lead History', 74, 1),
                    ),
                    const SizedBox(width: 37.7),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 2;
                        });
                      },
                      child: topics('Appointment', 79, 2),
                    ),
                    const SizedBox(width: 37.7),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 3;
                        });
                      },
                      child: topics('Notes', 34, 3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: selectedIndex == 0
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            selectedIndex == 0 ? const ChatPage() : const SizedBox(),
            selectedIndex == 1 ? const LeadHistory() : const SizedBox(),
            selectedIndex == 2 ? const AppointmentPage() : const SizedBox(),
            selectedIndex == 3 ? const NotePage() : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget topics(String text, double width, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 18,
          // width: selectedIndex == index ? width + 1 : width,
          child: Text(
            text,
            style: TextStyle(
              fontFamily: MyStrings.outfit,
              fontSize: 13,
              fontWeight:
                  selectedIndex == index ? FontWeight.w600 : FontWeight.w400,
              color: selectedIndex == index
                  ? const Color(0xffFFFFFF)
                  : const Color(0xff8B8E8C),
            ),
          ),
        ),
        const SizedBox(width: 3),
        selectedIndex == index
            ? Container(
                height: 4,
                width: 10,
                decoration: BoxDecoration(
                    color: const Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(6)),
              )
            : Container()
      ],
    );
  }
}
