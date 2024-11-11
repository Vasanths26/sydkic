import 'package:flutter/material.dart';

import '../../../utils/constant.dart';
import '../../../utils/string.dart';

class InterestedPage extends StatefulWidget {
  const InterestedPage({super.key});

  @override
  State<InterestedPage> createState() => _InterestedPageState();
}

class _InterestedPageState extends State<InterestedPage> {
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
                child: Image.asset('asset/image/bubble.png',
                    height: 13.5, width: 13.5),
              ),
              const SizedBox(width: 10),
              const Padding(
                padding: EdgeInsets.only(top: 7.5, bottom: 7.5),
                child: Text(
                  'Interested',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: MyStrings.outfit,
                    color: Color(0xff8B8E8C),
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
                  '02',
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
        const SizedBox(height: 20),
        ListView.builder(
            itemCount: 2,
            shrinkWrap: true,
            itemBuilder: (context, index) {
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
                            'Jeevan',
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
                      const Text(
                        'Customer inquires about available lime slots and schedules a midnight appoinment.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          fontFamily: MyStrings.outfit,
                          color: Color(0xff8B8E8C),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 1,
                        width: 313,
                        decoration: const BoxDecoration(
                          color: Color(0xff373737),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const SizedBox(
                            height: 18,
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 1, bottom: 1.5),
                                    child: Icon(Icons.calendar_month,
                                        size: 18, color: Colors.white),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Nov 09, 2024',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: MyStrings.outfit,
                                      color: Color(0xff8B8E8C),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 0.75, bottom: 0.06),
                                    child: Icon(Icons.chat_outlined,
                                        size: 18, color: Colors.white),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
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
                          Container(
                              height: 22,
                              padding:
                                  const EdgeInsets.only(left: 6.5, right: 6.5),
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(5),
                              //   border: Border.all(
                              //       color: const Color(0xff8B8E8C),
                              //       width: 1,
                              //       strokeAlign: BorderSide.strokeAlignCenter),
                              // ),
                              child: CustomPaint(
                                painter: DashedBorderPainter(
                                    color: const Color(0xff8B8E8C)),
                                child: const Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
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
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  DashedBorderPainter({required this.color, this.strokeWidth = 1});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
