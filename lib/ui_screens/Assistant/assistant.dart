import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sydkic/utils/constant.dart';

import '../../utils/string.dart';

class GroupAssistant extends StatefulWidget {
  const GroupAssistant({super.key, required this.topic});

  final String topic;
  @override
  State<GroupAssistant> createState() => _GroupAssistantState();
}

class _GroupAssistantState extends State<GroupAssistant> {
  List<bool> switchStates = List.generate(10, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff000000),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Icon(Icons.arrow_back, color: whiteColor, size: 20),
          ),
        ),
        title: Text(
          widget.topic,
          style: TextStyle(
            fontSize: 20,
            color: whiteColor,
            fontFamily: MyStrings.outfit,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(
              Icons.more_vert,
              color: whiteColor,
              size: 20,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xff000000),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ListView.builder(
            itemCount: 4,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return contact(index);
            }),
      ),
    );
  }

  Widget contact(int index) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      padding:
          const EdgeInsets.only(left: 20, top: 12.5, bottom: 12.5, right: 20),
      child: Row(
        children: [
          GestureDetector(
            child: SizedBox(
              child: Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffFFFFFF),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: 'asset/image/round_profile.webp',
                        errorWidget: (context, url, error) => const Center(
                          child: Text(
                            '', // + and first two digits of phone number
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black, // Text color
                                fontWeight: FontWeight.w400,
                                fontFamily: MyStrings.outfit),
                          ),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 24,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Rose',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontFamily: MyStrings.outfit),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          logo('asset/image/whatsapp-logo.png'),
                          const SizedBox(width: 5),
                          logo('asset/image/instagram-device 1.png'),
                          const SizedBox(width: 5),
                          logo('asset/image/envelope-device 1.png'),
                          // index == 3
                          //     ? logo('asset/image/web-chat 1.png')
                          //     : const SizedBox()
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 16,
                  width: 60,
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(bottom: 14),
                  child: const Text(
                    // userContact.assistantContact
                    //         ?.assistantName ??
                    'Nov 4,2024',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff8B8E8C),
                        fontFamily: MyStrings.outfit),
                  ),
                ),
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
                          switchStates[index] = value;
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
        ],
      ),
    );
  }

  Widget logo(String image) {
    return Stack(
      children: [
        Container(
          height: 24,
          width: 24,
          padding: const EdgeInsets.all(5.52),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xff393939),
          ),
          child: Image.asset(
            image,
            width: 13.6,
            height: 13.6,
          ),
        ),
        // Positioned(
        //   top: 0,
        //   right: 3,
        //   child: Container(
        //     height: 4.8,
        //     width: 4.8,
        //     decoration: const BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
