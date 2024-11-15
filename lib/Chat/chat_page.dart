import 'package:flutter/material.dart';

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
  String? _selectedOption = 'Option 1';
  int selectedIndex = 0;
  // double _containerHeight = 55; // Initial height

  // @override
  // void initState() {
  //   super.initState();
  //   _controller.addListener(_updateHeight);
  // }

  // void _updateHeight() {
  //   final int lineCount = '\n'.allMatches(_controller.text).length + 1;
  //   setState(() {
  //     // Update height, allowing up to 6 lines
  //     _containerHeight =
  //         55 + ((lineCount - 1) * 20).clamp(0, 20 * 5).toDouble();
  //   });
  // }

  void _handleRadioValueChange(String? value) {
    setState(() {
      _selectedOption = value;
    });
  }

  void _sendMessage() {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        messages.insert(0, {"text": message, "isUser": true});
      });
      _controller.clear();
    }
  }

  // @override
  // void dispose() {
  //   _controller.removeListener(_updateHeight);
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height:
              MediaQuery.of(context).size.height * 0.8, // 80% of screen height
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
                                  ? const Color(0xff242824)
                                  : const Color(0xffF0F2F5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              messages[reverseIndex]["text"],
                              style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: MyStrings.outfit,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      isSentByUser ? whiteColor : Colors.black),
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
              color: const Color(0xffF4F4F4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Align vertically centered
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.mood_outlined,
                    color: Color(0xff121212),
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
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Message...',
                      hintStyle: TextStyle(
                        color: Color(0xff8B8E8C),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: MyStrings.outfit,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Color(0xff1C1B1F)),
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
                    decoration: const BoxDecoration(
                      color: Color(0xffFFFFFF),
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
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff121212),
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
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                const SizedBox(height: 15),
                SizedBox(
                  // height: 18,
                  // width: 133,
                  child: Text(
                    'Choose a Platform',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: blackColor),
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(
                  height: 18,
                  // width: 192,
                  child: Text('Pick a Way to Send Your Message'),
                ),
                const SizedBox(height: 25),
                platform('asset/image/business-device 1.png', '+919943858300',
                    'Option 1'),
                const SizedBox(height: 15),
                platform('asset/image/talk 1.png', '+916385402959', 'Option 2'),
                const SizedBox(height: 15),
                platform('asset/image/instagram-device 1.png', 'Instagram',
                    'Option 3'),
                const SizedBox(height: 15),
                platform('asset/image/slack-device 1.png', 'Slack', 'Option 4'),
                const SizedBox(height: 15),
                platform('asset/image/envelope-device 1.png',
                    'praveen@nidanatech.com', 'Option 5'),
                const SizedBox(height: 15),
                platform('asset/image/web-chat 1.png', 'Chatbot', 'Option 6'),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 38,
                      width: 145,
                      decoration: BoxDecoration(
                          border: Border.all(color: blackColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                          color: whiteColor),
                      child: Center(
                        child: Text(
                          'Back',
                          style: TextStyle(
                              color: blackColor,
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
                          color: blackColor),
                      child: Center(
                        child: Text(
                          'select',
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
          ),
        );
      },
    );
  }

  Widget platform(String image, String text, String option) {
    return Container(
      height: 42,
      width: 353,
      decoration: BoxDecoration(
        color: const Color(0xffF0F2F5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Image.asset(image, fit: BoxFit.cover),
          ),
          const SizedBox(width: 15),
          SizedBox(
            // height: 18,
            // width: 186,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontFamily: MyStrings.outfit,
                color: blackColor,
              ),
            ),
          ),
          const Spacer(),
          Radio<String>(
            value: option,
            groupValue: _selectedOption,
            onChanged: _handleRadioValueChange,
          ),
        ],
      ),
    );
  }
}
