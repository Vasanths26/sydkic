import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sydkic/utils/small_text.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sydkic/utils/constant.dart';
import 'package:sydkic/utils/string.dart';
import 'package:http/http.dart' as http;
import '../model/scheduled_model.dart';
import '../utils/api_constant.dart';

class AppointmentProvider extends ChangeNotifier {
  List<ScheduleList> _scheduledList = [];
  int _selectedIndex = 0;
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;
  List<ScheduleList> get scheduleList => _scheduledList;
  int get selectedIndex => _selectedIndex;
  bool get isLoading => _isLoading;

  Future<void> fetchScheduledList(DateTime date) async {
    _isLoading = true;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('authorization');
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(date);

    if (kDebugMode) {
      print("access token $token");
    }
    try {
      var response = await http.get(
        Uri.parse('${ApiConstants.getScheduledList}/$formattedDate'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        ScheduledModel scheduledModel = ScheduledModel.fromJson(jsonData);
        _scheduledList = scheduledModel.scheduleList!;
      } else {
        if (kDebugMode) {
          print('Failed to fetch assistant: ${response.statusCode}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching assistant: $error');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectDate(DateTime date, int index) {
    _selectedDate = date;
    _selectedIndex = index;
    fetchScheduledList(date);
    notifyListeners();
  }
}

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  bool _isExpanded = false;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  void _toggleExpandCollapse(double dragOffset) {
    setState(() {
      _isExpanded = dragOffset > 0;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black, // Status bar background color
        statusBarIconBrightness:
            Brightness.light, // Light icons for dark background
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: blackColor,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, top: 15, right: 20),
                height: 64,
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: commonColor,
                  image: const DecorationImage(
                      image: AssetImage('asset/image/image.png'),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  children: [
                    // Container(
                    //   height: 46,
                    //   padding: const EdgeInsets.only(
                    //     left: 20,
                    //     right: 7,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(28),
                    //     color: blackColor.withOpacity(0.5),
                    //     border: Border.all(color: primaryColor, width: 1),
                    //     boxShadow: [
                    //       BoxShadow(
                    //           color: Colors.black
                    //               .withOpacity(0.3), // Light black shadow
                    //           offset: const Offset(5,
                    //               5), // Horizontal and vertical shadow position
                    //           blurRadius: 10,
                    //           spreadRadius: 0 // Spread radius
                    //           ),
                    //     ],
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.only(
                    //           top: 14,
                    //           bottom: 14,
                    //         ),
                    //         child: Icon(Icons.search,
                    //             color: primaryColor, size: 18),
                    //       ),
                    //       const SizedBox(width: 10),
                    //       Expanded(
                    //         child: Padding(
                    //           padding: const EdgeInsets.only(
                    //               top: 13.5, bottom: 13.5),
                    //           child: TextFormField(
                    //             controller: _controller,
                    //             keyboardType: TextInputType.multiline,
                    //             style: TextStyle(
                    //               fontSize: 12,
                    //               fontWeight: FontWeight.w400,
                    //               fontFamily: MyStrings.outfit,
                    //               color: whiteColor,
                    //             ),
                    //             decoration: InputDecoration(
                    //               border: InputBorder.none,
                    //               hintText: 'Search Name, Number, IG',
                    //               hintStyle: TextStyle(
                    //                 color: homeTextColor,
                    //                 fontFamily: MyStrings.outfit,
                    //                 fontWeight: FontWeight.w400,
                    //                 fontSize: 13,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Container(
                    //         height: 32,
                    //         width: 32,
                    //         padding: const EdgeInsets.all(2),
                    //         decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           gradient: LinearGradient(
                    //             colors: [
                    //               whitecolor.withOpacity(1),
                    //               primaryColor.withOpacity(1),
                    //             ],
                    //           ),
                    //         ),
                    //         child: ClipOval(
                    //           child: Image.asset(
                    //             'asset/image/round_profile.webp',
                    //             fit: BoxFit.cover,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _focusedDay = DateTime(
                                  _focusedDay.year, _focusedDay.month - 1);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: forIcon(Icons.arrow_back_ios, 10),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Column(
                            children: [
                              Text(
                                DateFormat('MMMM').format(_selectedDay),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: MyStrings.outfit,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                DateFormat('yyyy').format(_selectedDay),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: MyStrings.outfit,
                                  color: secondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _focusedDay = DateTime(
                                  _focusedDay.year, _focusedDay.month + 1);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: forIcon(Icons.arrow_forward_ios, 5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  // Drag down to expand, drag up to collapse
                  if (details.primaryDelta != null) {
                    _toggleExpandCollapse(details.primaryDelta!);
                  }
                },
                child: SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/image/image.png'),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      // color: Color(0xff302660),
                    ),
                    padding:
                        const EdgeInsets.only(left: 20, top: 12.21, right: 20),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          alignment: Alignment.centerLeft,
                          duration: const Duration(milliseconds: 300),
                          height: _isExpanded
                              ? MediaQuery.of(context).size.height * 0.37
                              : MediaQuery.of(context).size.height * 0.105,
                          width: MediaQuery.of(context).size.height * 0.6,
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          child: TableCalendar(
                            daysOfWeekHeight: 30,
                            firstDay: DateTime.utc(1970, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: _focusedDay,
                            headerVisible: false,
                            headerStyle: const HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                            ),
                            calendarFormat: _isExpanded
                                ? CalendarFormat.month
                                : CalendarFormat.week,
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                            onPageChanged: (newfocusedDay) {
                              setState(() {
                                _focusedDay = DateTime(newfocusedDay.year,
                                    newfocusedDay.month, newfocusedDay.day);
                                _selectedDay = DateTime(
                                    newfocusedDay.year, newfocusedDay.month);
                              });
                            },
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekendStyle: TextStyle(
                                color: secondaryColor, // Color for weekend days
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                fontFamily: MyStrings.outfit,
                              ),
                              weekdayStyle: TextStyle(
                                color: secondaryColor, // Color for weekdays
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                fontFamily: MyStrings.outfit,
                              ),
                            ),
                            calendarBuilders: CalendarBuilders(
                              weekNumberBuilder: (context, day) {
                                return Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        // Customize day text appearance
                                        day.toString(),
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ), // Adjust spacing as needed
                                      Text(
                                        // Customize date text appearance
                                        day.toString(),
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              todayBuilder: (context, day, focusedDay) {
                                return Container(
                                  height: 40,
                                  width: 40,
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: whiteColor),
                                  ),
                                  child: Center(
                                    child: Text(
                                      day.day.toString(),
                                      style: TextStyle(color: whiteColor),
                                    ),
                                  ),
                                );
                              },
                              defaultBuilder: (context, day, focusedDay) {
                                return Container(
                                  height: 30,
                                  width: 30,
                                  margin: const EdgeInsets.all(8),
                                  child: Center(
                                    child: Text(
                                      day.day.toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                            ),
                            calendarStyle: CalendarStyle(
                              todayTextStyle: TextStyle(color: whiteColor),
                              todayDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: whiteColor,
                                ),
                              ),
                              cellMargin: const EdgeInsets.all(8),
                              cellPadding: const EdgeInsets.all(6),
                              cellAlignment: Alignment.center,
                              markerSize: 4.16,
                              markersMaxCount: 3,
                              markersAlignment: Alignment.bottomCenter,
                              markerDecoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: blackColor,
                              ),
                              selectedDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: whiteColor,
                              ),
                              selectedTextStyle: TextStyle(color: blackColor),
                              defaultTextStyle:
                                  TextStyle(color: secondaryColor),
                              weekendTextStyle:
                                  TextStyle(color: secondaryColor),
                              outsideTextStyle:
                                  const TextStyle(color: Color(0xff8F9BB3)),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onVerticalDragUpdate: (details) {
                            // Drag down to expand, drag up to collapse
                            if (details.primaryDelta != null) {
                              _toggleExpandCollapse(details.primaryDelta!);
                            }
                          },
                          child: Container(
                            height: 4,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: primaryColor,
                            ),
                            margin: const EdgeInsets.only(top: 10),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SmallText(
                      text: MyStrings.appointments,
                      size: 13,
                      color: homeTextColor,
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
                                border: GradientBoxBorder(
                                  width: 1,
                                  gradient: LinearGradient(
                                    colors: [
                                      primaryColor, // #5548B1 at 30% opacity
                                      primaryColor.withOpacity(
                                          0.3), // #5548B1 at 30% opacity
                                    ], // Defines the distribution of colors
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: appointmentConColor),
                            child: Column(
                              children: [
                                SmallText(
                                  text: MyStrings.content,
                                  size: 13,
                                  color: homeTextColor,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: MyStrings.outfit,
                                  maxLine: 2,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.person_2,
                                      color: primaryColor,
                                      size: 18,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SmallText(
                                      text: MyStrings.name,
                                      size: 10,
                                      color: secondaryColor,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: MyStrings.outfit,
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      size: 18,
                                      color: primaryColor,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SmallText(
                                      text: MyStrings.date,
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
                                      size: 18,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget forIcon(IconData icons, double lefts) {
    return Container(
      height: 34,
      width: 34,
      margin: const EdgeInsets.only(bottom: 13.79),
      padding: EdgeInsets.only(left: lefts, right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: const Color(0xffCED3DE),
        ),
      ),
      child: Center(
        child: Icon(
          size: 18,
          icons,
          color: whiteColor,
        ),
      ),
    );
  }
}
