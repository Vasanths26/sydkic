import 'package:flutter/material.dart';
import 'package:sydkic/Chat/bio_screen.dart';
import 'package:sydkic/utils/string.dart';
import '../ui_screens/contact_assitent.dart';
import '../utils/constant.dart';
import 'appointment_page.dart';
import 'chat_page.dart';
import 'lead_history.dart';
import 'note_page.dart';
import 'profile_page.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.contactID, required this.onSave});

  final int contactID;
  final VoidCallback onSave;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();

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
  final ScrollController _scrollController = ScrollController();

  void _scrollToSelectedIndex() {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth =
        100; // Approximate width of each button (adjust as needed)
    double targetPosition =
        (selectedIndex * buttonWidth) - (screenWidth - buttonWidth) / 2;
    targetPosition =
        targetPosition.clamp(0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundcolor,
      appBar: AppBar(
        scrolledUnderElevation: 0.0, // This will fix the problem
        automaticallyImplyLeading: false,
        backgroundColor: blackColor,
        toolbarHeight: 130,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 50),
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
                      child: Icon(Icons.arrow_back, color: primaryColor),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dianne Russell',
                            style: TextStyle(
                              fontFamily: MyStrings.outfit,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: whiteColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '7418601714',
                            style: TextStyle(
                              fontFamily: MyStrings.outfit,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: secondaryColor,
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
                      child: Transform.scale(
                        scale: 0.75,
                        child: Switch(
                          value: switchState,
                          onChanged: (value) {
                            showContactAssistantModal(
                                context, widget.contactID, widget.onSave);
                            setState(() {
                              switchState = value; // Update the switch state
                            });
                          },
                          trackOutlineColor:
                              const WidgetStatePropertyAll(Colors.transparent),
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
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(tabTitles.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          _pageController.jumpToPage(index);
                          _scrollToSelectedIndex();
                        });
                      },
                      child: topics(tabTitles[index], index),
                    );
                  }),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double
                    .infinity, // Ensures the container spans the full width
                height: 1, // Sets the height of the divider line
                color: const Color(0xff242824), // Line color (adjust as needed)
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
            _scrollToSelectedIndex();
          });
        },
        children: pages,
      ),
    );
  }

  void showContactAssistantModal(
      BuildContext context, int? contactId, VoidCallback onSave) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: ContactAssitentComponent(
            contactid: contactId,
            onSave: onSave,
          ),
        );
      },
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
