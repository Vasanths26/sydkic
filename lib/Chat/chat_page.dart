import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../utils/constant.dart';
import '../utils/string.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, dynamic>> messages = [
    {"text": "Hi! I'm Dianne Russell", "isUser": false},
    {"text": "Hello! Dianne Russell 😊.", "isUser": true},
    {"text": "Can you help me improve my lifestyle?", "isUser": false},
    {"text": "I'd be happy to help 😊.", "isUser": true},
    {
      "text":
          'What aspects of your lifestyle are you looking to improve? Fitness, diet, sleep, or something else?',
      "isUser": true
    },
    {
      "text": "I want to eat healthier and get fit. Any suggestions?",
      "isUser": false
    },
    {
      "text":
          "Great goals! 🥦🏋️ Let's start with your diet. Are you looking to lose weight, gain muscle, or just eat more nutritious foods?",
      "isUser": true
    },
    {"text": "I want to lose some weight and tone up.", "isUser": false},
    {
      "text":
          "Awesome! For weight loss, try to focus on eating whole, unprocessed foods like vegetables, fruits, lean proteins, and whole grains. 🥗🍗 Aim to reduce sugary drinks and snacks. Do you already exercise, or are you just getting started?",
      "isUser": true
    },
  ];
  final TextEditingController _controller = TextEditingController();
  String? _selectedOption;
  int selectedIndex = 0;

  void _sendMessage() {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        messages.insert(0, {"text": message, "isUser": true});
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: blackColor,
          height:
              MediaQuery.of(context).size.height * 0.85, // 80% of screen height
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    int reverseIndex = messages.length - 1 - index;
                    bool isSentByUser = messages[reverseIndex]["isUser"];
                    bool showInfo = true;
                    if (reverseIndex < messages.length - 1 &&
                        messages[reverseIndex + 1]["isUser"] == isSentByUser) {
                      showInfo = false;
                    }
                    return Column(
                      crossAxisAlignment: isSentByUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: isSentByUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 14),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7),
                            decoration: BoxDecoration(
                              color: isSentByUser
                                  ? primaryColor
                                  : appointmentConColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              messages[reverseIndex]["text"],
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: MyStrings.outfit,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      isSentByUser ? whiteColor : whiteColor),
                            ),
                          ),
                        ),
                        if (showInfo)
                          Row(
                            mainAxisAlignment: isSentByUser
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              isSentByUser
                                  ? Container()
                                  : Container(
                                      height: 15,
                                      width: 15,
                                      margin: const EdgeInsets.only(right: 5),
                                      child: Image.asset(
                                        'asset/image/whatsapp-logo.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              const SizedBox(
                                height: 10,
                                width: 38,
                                child: Text(
                                  '10:00am',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontFamily: MyStrings.outfit,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff8B8E8C),
                                  ),
                                ),
                              ),
                              isSentByUser
                                  ? Container(
                                      height: 15,
                                      width: 15,
                                      margin: const EdgeInsets.only(right: 5),
                                      child: Image.asset(
                                        'asset/image/whatsapp-logo.png',
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 10,
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              border: GradientBoxBorder(
                width: 1,
                gradient: LinearGradient(
                  colors: [
                    primaryColor, // #5548B1 at 30% opacity
                    primaryColor.withOpacity(0.3), // #5548B1 at 30% opacity
                  ], // Defines the distribution of colors
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
              ),
              color: blackColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Align vertically centered
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.mood_outlined,
                    color: whitecolor,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    minLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: MyStrings.outfit,
                      color: blackColor,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Message...',
                      hintStyle: TextStyle(
                        color: secondaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        fontFamily: MyStrings.outfit,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.attach_file, color: whitecolor),
                  iconSize: 18,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  onPressed: () {},
                ),
                InkWell(
                  onTap: () {
                    showBottomSheet();
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: whitecolor,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'asset/image/whatsapp-logo.png',
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    _sendMessage();
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                    child: const Icon(
                      Icons.send_outlined,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showBottomSheet() {
    final platforms = [
      {
        "image": "asset/image/business-device 1.png",
        "text": "+919943858300",
        "option": "Option 1"
      },
      {
        "image": "asset/image/talk 1.png",
        "text": "+916385402959",
        "option": "Option 2"
      },
      {
        "image": "asset/image/instagram-device 1.png",
        "text": "Instagram",
        "option": "Option 3"
      },
      {
        "image": "asset/image/slack-device 1.png",
        "text": "Slack",
        "option": "Option 4"
      },
      {
        "image": "asset/image/envelope-device 1.png",
        "text": "praveen@nidanatech.com",
        "option": "Option 5"
      },
      {
        "image": "asset/image/web-chat 1.png",
        "text": "Chatbot",
        "option": "Option 6"
      },
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        String? selectedOption = _selectedOption; // Initialize local state

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: 519,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    height: 5,
                    width: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xff8B8E8C),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choose a Platform',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: primaryColor),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pick a Way to Send Your Message',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: secondaryColor),
                          ),
                        ],
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close, size: 20, color: primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: ListView.builder(
                      itemCount: platforms.length,
                      itemBuilder: (context, index) {
                        final platform = platforms[index];
                        return Column(
                          children: [
                            Container(
                              height: 42,
                              padding: const EdgeInsets.only(
                                  left: 10, right: 15, top: 6, bottom: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xffF0F2F5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle),
                                    child: Image.asset(
                                      platform["image"]!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  SizedBox(
                                    width: 232,
                                    child: Text(
                                      platform["text"]!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: MyStrings.outfit,
                                        color:
                                            selectedOption == platform["option"]
                                                ? blackColor
                                                : const Color(0xff8B8E8C),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Radio<String>(
                                    value: platform["option"]!,
                                    groupValue: selectedOption,
                                    onChanged: (value) {
                                      setModalState(() {
                                        selectedOption = value;
                                      });
                                      setState(() {
                                        _selectedOption = value;
                                      });
                                    },
                                    activeColor: primaryColor,
                                  ),
                                ],
                              ),
                            ),
                            if (index != platforms.length - 1)
                              const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 38,
                        width: 145,
                        decoration: BoxDecoration(
                            border: Border.all(color: primaryColor, width: 1),
                            borderRadius: BorderRadius.circular(12),
                            color: whiteColor),
                        child: Center(
                          child: Text(
                            'Back',
                            style: TextStyle(
                                color: primaryColor,
                                fontFamily: MyStrings.outfit,
                                fontWeight: FontWeight.w400,
                                fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(width: 23),
                      Container(
                        height: 38,
                        width: 145,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: primaryColor),
                        child: Center(
                          child: Text(
                            'Select',
                            style: TextStyle(
                                color: whiteColor,
                                fontFamily: MyStrings.outfit,
                                fontWeight: FontWeight.w400,
                                fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
