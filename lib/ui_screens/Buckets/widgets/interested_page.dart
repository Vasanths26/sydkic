import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../utils/constant.dart';
import '../../../utils/string.dart';

class InterestedPage extends StatefulWidget {
  const InterestedPage(
      {super.key,
      required this.topics,
      required this.images,
      required this.items});
  final String topics;
  final String images;
  final List<Map<String, String>> items;
  @override
  State<InterestedPage> createState() => _InterestedPageState();
}

class _InterestedPageState extends State<InterestedPage> {
  int selectedIndex = 0;
  int currentIndex = 0;

  late List<Map<String, String>> currentList;

  @override
  void initState() {
    super.initState();
    currentList = List.from(widget.items); // Initialize with passed list
  }

  void moveItem(int index, String targetTopic) {
    setState(() {
      // Assuming you handle moving the item to the respective list of `targetTopic`
      currentList.removeAt(index); // Remove from current list
      // Here you would add this item to the target topic list, e.g., topic2Items
    });
    Navigator.pop(context); // Close the bottom sheet
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 35,
                width: 35,
                padding: const EdgeInsets.all(10.75),
                decoration: const BoxDecoration(
                    color: Color(0xff393939), shape: BoxShape.circle),
                child: Image.asset(widget.images, height: 13.5, width: 13.5),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 7.5, bottom: 7.5),
                  child: Text(
                    widget.topics,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: MyStrings.outfit,
                      color: Color(0xff8B8E8C),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_upward_outlined,
                color: Color(0xffFFD002),
                size: 18,
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(top: 1, bottom: 1),
                child: Text(
                  '${widget.items.length}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: MyStrings.outfit,
                    color: whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        // const SizedBox(height: 20),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.67,
          child: ListView.builder(
              itemCount: widget.items.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final text1 = widget.items[index]['text1'] ?? 'Default Text 1';
                final text2 = widget.items[index]['text2'] ?? 'Default Text 1';
                final text3 = widget.items[index]['text3'] ?? 'Default Text 1';
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xff1A1C1A),
                  ),
                  // height: 150,
                  width: 353,
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text1,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: MyStrings.outfit,
                                color: whiteColor,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              height: 24,
                              width: 24,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff393939),
                              ),
                              alignment: Alignment.center,
                              child: Image.asset(
                                'asset/image/instagram-device 1.png',
                                height: 14,
                                width: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 9),
                        Text(
                          text2,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            fontFamily: MyStrings.outfit,
                            color: Color(0xff8B8E8C),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 1,
                          // width: 313,
                          decoration: const BoxDecoration(
                            color: Color(0xff373737),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            SizedBox(
                              height: 18,
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(top: 1, bottom: 1.5),
                                      child: Icon(Icons.calendar_month,
                                          size: 18, color: Colors.white),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      text3,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: MyStrings.outfit,
                                        color: Color(0xff8B8E8C),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 0.75, bottom: 0.06),
                                      child: Icon(Icons.chat_outlined,
                                          size: 18, color: Colors.white),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      '14',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: MyStrings.outfit,
                                        color: Color(0xff8B8E8C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  currentIndex = index;
                                });
                                showBottom();
                              },
                              child: Container(
                                height: 22,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5)),
                                child: DottedBorder(
                                  color: const Color(0xff8B8E8C),
                                  strokeWidth: 1,
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(
                                      5), // Sets the border radius
                                  dashPattern: const [
                                    6,
                                    3
                                  ], // Adjust dash and gap lengths
                                  child: const Center(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 6.5),
                                        Icon(Icons.drive_file_move_outline,
                                            color: Colors.white, size: 16),
                                        SizedBox(width: 6.62),
                                        Text(
                                          'Move',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: MyStrings.outfit,
                                            color: Color(0xff8B8E8C),
                                          ),
                                        ),
                                        SizedBox(width: 6.5),
                                      ],
                                    ),
                                  ),
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
        ),
      ],
    );
  }

  void showBottom() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return const BottomSheetUI();
      },
    );

    if (result != null) {
      String selectedTopic = result['text'];
      int selectedIndex = result['index'];
      moveItem(selectedIndex, selectedTopic);

      print('Selected Topic: $selectedTopic, Index: $selectedIndex');
    }
  }
}

class BottomSheetUI extends StatefulWidget {
  const BottomSheetUI({super.key});

  @override
  State<BottomSheetUI> createState() => _BottomSheetUIState();
}

class _BottomSheetUIState extends State<BottomSheetUI> {
  int selectedIndex = 0;
  String selectedTopic = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 294,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: whiteColor,
      ),
      padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.drive_file_move_outline,
                  color: Colors.black, size: 25),
              const SizedBox(width: 12.5),
              const Text(
                'Move',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: MyStrings.outfit,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'text': selectedTopic,
                      'index': selectedIndex,
                    });
                  },
                  icon:
                      Icon(Icons.close_outlined, size: 24, color: blackColor)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              topic('Interested', 0),
              const SizedBox(width: 14),
              topic('Budget Concern', 1),
              const SizedBox(width: 14),
              topic('Spam', 2),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              topic('Not Intersted - Currently No Need', 3),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              topic('Enquiring', 4),
              const SizedBox(width: 14),
              topic('Help', 5),
              const SizedBox(width: 14),
              topic('Immediate Action', 6),
            ],
          ),
        ],
      ),
    );
  }

  Widget topic(String text, int index) {
    bool isSelected = selectedIndex == index;
    Color containerColor =
        isSelected ? const Color(0xff1A1C1A) : const Color(0xffF0F2F5);
    Color textColor = isSelected ? Colors.white : Colors.black;

    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
          selectedTopic = text;
          Navigator.pop(context);
        });
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: containerColor,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                fontFamily: MyStrings.outfit),
          ),
        ),
      ),
    );
  }
}
