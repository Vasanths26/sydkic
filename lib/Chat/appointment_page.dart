import 'package:flutter/material.dart';
import 'package:sydkic/utils/constant.dart';
import '../utils/small_text.dart';
import '../utils/string.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: appointmentConColor,
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add the appointment',
                  hintStyle: TextStyle(
                    color: appointmentText,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontFamily: MyStrings.outfit,
                  ),
                  suffixIcon: Container(
                    height: 20,
                    width: 20,
                    // padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: primaryColor,
                    ),
                    child: Center(
                      child: Icon(Icons.add_circle_outline,
                          size: 12, color: whiteColor),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            SmallText(
              text: MyStrings.appointments,
              size: 16,
              color: primaryColor,
              fontWeight: FontWeight.w500,
              fontFamily: MyStrings.outfit,
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(bottom: 10),
                    // height: 150,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        // border: GradientBoxBorder(
                        //   width: 1,
                        //   gradient: LinearGradient(
                        //     colors: [
                        //       primaryColor, // #5548B1 at 30% opacity
                        //       primaryColor
                        //           .withOpacity(0.3), // #5548B1 at 30% opacity
                        //     ], // Defines the distribution of colors
                        //     begin: Alignment.topLeft,
                        //     end: Alignment.topRight,
                        //   ),
                        // ),
                        borderRadius: BorderRadius.circular(5),
                        color: appointmentConColor),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.64,
                              child: SmallText(
                                text: MyStrings.content,
                                size: 13,
                                color: homeTextColor,
                                fontWeight: FontWeight.w400,
                                fontFamily: MyStrings.outfit,
                                maxLine: 2,
                              ),
                            ),
                            const SizedBox(width: 57),
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: primaryColor,
                              ),
                              child: Center(
                                child: Image.asset('asset/image/box_edit.png',
                                    height: 9, width: 10),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              size: 18,
                              color: primaryColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SmallText(
                              text: '10-07-2024',
                              size: 10,
                              color: secondaryColor,
                              fontWeight: FontWeight.w400,
                              fontFamily: MyStrings.outfit,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Icon(
                              Icons.access_time_filled_rounded,
                              size: 20,
                              color: primaryColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SmallText(
                              text: MyStrings.time,
                              size: 10,
                              color: secondaryColor,
                              fontWeight: FontWeight.w400,
                              fontFamily: MyStrings.outfit,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
