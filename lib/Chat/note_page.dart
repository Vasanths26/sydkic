import 'package:flutter/material.dart';

import '../utils/constant.dart';
import '../utils/string.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff242824),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                children: [
                  TextFormField(
                    maxLines:
                        null, // Allows the TextFormField to expand vertically
                    minLines: 5, // Sets an initial height with 5 lines
                    decoration: InputDecoration(
                      hintText: "Take a note here...",
                      hintStyle: TextStyle(
                          color: secondaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: MyStrings.outfit),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 15,
                    child: Container(
                      height: 28,
                      width: 28,
                      margin: const EdgeInsets.only(top: 93, right: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xff5548b1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Icon(Icons.save_outlined,
                            color: whiteColor, size: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 160,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xff242824),
              ),
              padding: const EdgeInsets.only(
                  top: 15, left: 15, right: 10, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                    width: 323,
                    child: Text(
                      'Awesome! For weight loss, try to focus on eating whole, unprocessed foods like vegetables, fruits, lean proteins, and whole grains.',
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: 16,
                          // height: 1.5,
                          fontWeight: FontWeight.w400,
                          fontFamily: MyStrings.outfit),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 18,
                        width: 286,
                        child: Text(
                          'By praveen on 11 Oct, 2024',
                          style: TextStyle(
                              color: Color(0xff8B8E8C),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              fontFamily: MyStrings.outfit),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 20,
                        width: 20,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xffF41313),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        // padding: const EdgeInsets.all(2),
                        child: Icon(Icons.delete_outlined,
                            color: whiteColor, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
