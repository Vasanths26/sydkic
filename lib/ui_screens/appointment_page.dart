import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sydkic/utils/constant.dart';
import 'package:sydkic/utils/string.dart';
import 'package:http/http.dart' as http;
import '../model/scheduled_model.dart';
import '../utils/api_constant.dart';

class AppointmentProvider extends ChangeNotifier{
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
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  // bool _isDate = false;
  bool _isMonth = false;
  bool _isExpanded = false;
  // final List<Event> _eventDates = [
  //   Event(DateTime(2024, 7, 22), 'Meeting'),
  //   Event(DateTime(2024, 7, 25), 'Friend Birthday'),
  //   Event(DateTime(2024, 7, 20), 'Match day'),
  // ];

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    // _isDate = true;
    _isMonth = false;
  }

  // List<Event> _getEventsForDay(DateTime day) {
  //   return _eventDates.where((event) => isSameDay(event.date, day)).toList();
  // }

  // Event? getEventForSelectedDayString(String selectedDayString) {
  //   DateTime selectedDay =
  //       DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(selectedDayString);
  //   return _eventDates.firstWhere((event) => isSameDay(event.date, selectedDay),
  //       orElse: () => Event(DateTime.now(), "No Event"));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff121212),
        leading:Icon(
          Icons.menu,
          size: 30,
          color: whiteColor,
        ),
        title: Text(
          "Appoinment",
          style: TextStyle(
              color: whiteColor,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              fontFamily: MyStrings.outfit),
        ),
        actions: [
          Container(
            height: 24,
            width: 24,
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.only(
                top: 3.38, left: 3.4, right: 3.4, bottom: 3.42),
            child: Icon(Icons.search, color: whiteColor),
          ),
          Container(
            height: 24,
            width: 24,
            padding: const EdgeInsets.only(top: 2.24, bottom: 2.25),
            child: Icon(Icons.cached_outlined, color: whiteColor),
          ),
        ],
      ),
      backgroundColor: const Color(0xff121212),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   height: 30,
            //   alignment: Alignment.center,
            //   margin: const EdgeInsets.only(left: 20, right: 19.99, top: 40),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: [
            //       Container(
            //         padding: const EdgeInsets.only(top: 2, bottom: 6),
            //         child: Icon(
            //           Icons.menu,
            //           size: 30,
            //           color: primaryColor,
            //         ),
            //       ),
            //       const SizedBox(width: 20),
            //       Text(
            //         "Appoinment",
            //         style: TextStyle(
            //             color: primaryColor,
            //             fontSize: 22,
            //             fontWeight: FontWeight.w500,
            //             fontFamily: MyStrings.outfit),
            //       ),
            //       const Spacer(),
            //       Container(
            //         height: 24,
            //         width: 24,
            //         margin: const EdgeInsets.only(right: 20),
            //         padding: const EdgeInsets.only(
            //             top: 3.38, left: 3.4, right: 3.4, bottom: 3.42),
            //         child: Icon(Icons.search, color: blackColor),
            //       ),
            //       Container(
            //         height: 24,
            //         width: 24,
            //         padding: const EdgeInsets.only(top: 2.24, bottom: 2.25),
            //         child: Icon(Icons.cached_outlined, color: blackColor),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              height: 76,
              width: MediaQuery.of(context).size.width,
              padding:
                  const EdgeInsets.only(top: 24.22, left: 18, right: 14.44),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDay = DateTime(
                              _selectedDay.year, _selectedDay.month - 1);
                        });
                      },
                      child: forIcon(Icons.arrow_back_ios, 10)),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: SizedBox(
                      width: 130,
                      child: Column(
                        children: [
                          Text(
                            DateFormat('MMMM').format(_selectedDay),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              fontFamily: MyStrings.outfit,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            DateFormat('yyyy').format(_selectedDay),
                            style: const TextStyle(
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
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDay = DateTime(
                              _selectedDay.year, _selectedDay.month + 1);
                        });
                      },
                      child: forIcon(Icons.arrow_forward_ios, 5)),
                ],
              ),
            ),
            Container(
              // height: MediaQuery.of(context).size.height - 146,
              padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _isExpanded
                        ? MediaQuery.of(context).size.height * 0.37
                        : 0, // Adjust height as needed
                    width: _isExpanded
                        ? MediaQuery.of(context).size.height * 0.6
                        : 0,
                    decoration: _isExpanded
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xff121212),
                          )
                        : BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xffE5E5E5),
                          ),
                    margin: EdgeInsets.only(top: _isExpanded ? 10 : 0),
                    child: _isExpanded
                        ? TableCalendar(
                            // eventLoader: (day) => _getEventsForDay(day),
                            firstDay: DateTime.utc(1970, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            daysOfWeekStyle: const DaysOfWeekStyle(),
                            focusedDay: _focusedDay,
                            headerVisible: false,
                            headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true),
                            calendarFormat: _calendarFormat,
                            onHeaderTapped: (focusedDay) {
                              setState(() {
                                _selectedDay = DateTime(
                                    focusedDay.year, focusedDay.month + 1);
                              });
                            },
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                            onFormatChanged: (format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            },
                            calendarBuilders: CalendarBuilders(
                              todayBuilder: (context, day, focusedDay) {
                                return Container(
                                  height: 40,
                                  width: 40,
                                  margin: const EdgeInsets.only(bottom: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: primaryColor,
                                      width: 1,
                                    ),
                                  ),
                                  // Set your desired color
                                  child: Center(
                                    child: Text(day.day.toString(),
                                        style: TextStyle(color: whiteColor)),
                                  ),
                                );
                              },
                            ),
                            calendarStyle: CalendarStyle(
                              markerSize: 4.16,
                              markersMaxCount: 3,
                              markersAlignment: Alignment.bottomCenter,
                              markerDecoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                              ),
                              selectedDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                shape: BoxShape.rectangle,
                                color:
                                    blackColor, // Customize the selected day color here
                                border: Border.all(color:Colors.grey,width: 1)
                              ),
                              // Change current month's date color
                              defaultTextStyle: const TextStyle(color: Colors.white),  // Set the desired color for current month dates
                              weekendTextStyle: const TextStyle(color: Colors.white), // Same color for weekends
                              // Change color for dates outside the current month
                              outsideTextStyle: const TextStyle(color: Colors.grey), // You can modify this as well if needed
                            ),
                          )
                        : Container(),
                  ),
                  Container(
                    height: 5,
                    width: 62,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xffE5E5E5),
                    ),
                    margin: const EdgeInsets.only(top: 10),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: Row(
                      children: [
                        Text(
                          _isMonth == true
                              ? DateFormat('MMMM').format(_focusedDay)
                              : DateFormat('dd MMMM').format(_selectedDay),
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: 20,
                              fontFamily: MyStrings.outfit,
                              fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              // _isDate = true;
                              _isMonth = false;
                            });
                          },
                          child: Container(
                              height: 30,
                              width: 70,
                              margin: const EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                  color: _isMonth != true
                                      ? whiteColor
                                      : blackColor,
                                  border:Border.all(color:whiteColor,width:1),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Text("Today",
                                    style: TextStyle(
                                        color: _isMonth != true
                                            ? blackColor
                                            : whiteColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: MyStrings.outfit)),
                              )),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              // _isDate = false;
                              _isMonth = true;
                            });
                          },
                          child: Container(
                            height: 30,
                            width: 90,
                            decoration: BoxDecoration(
                              color: _isMonth == true
                                  ? whiteColor
                                  : const Color(0xff121212),
                              border:Border.all(color:whiteColor,width:1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                "This Month",
                                style: TextStyle(
                                    color: _isMonth == true
                                        ? blackColor
                                        : const Color(0xffFFFFFF),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: MyStrings.outfit),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: const Text(
                          "Time",
                          style: TextStyle(
                              color: Color(0xff8B8E8C),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: MyStrings.outfit),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 44, top: 30),
                        child: const Text(
                          "Appointment",
                          style: TextStyle(
                              color: Color(0xff8B8E8C),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: MyStrings.outfit),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ListView.builder(
                    itemCount: 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      // print('day:$_selectedDay');
                      // print('length:${_getEventsForDay(_selectedDay).length}');
                      // print('values:${_eventDates[index].times}');
                      return SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // _isMonth
                              //     ? DateFormat('dd MMMM')
                              //         .format(_eventDates[index].date)
                              // : getEventForSelectedDayString(
                              //             _selectedDay.toString())
                              //         ?.time ??
                              '',
                              style: TextStyle(
                                  color: blackColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: MyStrings.outfit),
                            ),
                            Container(
                              height: 40,
                              width: 0,
                              margin: const EdgeInsets.only(left: 20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: const Color(0xffE7E7E7),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 10),
                              width: _isMonth != true
                                  ? MediaQuery.of(context).size.width * 0.71
                                  : MediaQuery.of(context).size.width * 0.690,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                // color: const Color(0xffF8F8F8),
                              ),
                              margin:
                                  const EdgeInsets.only(left: 20, bottom: 25),
                              child: const Text(
                                  // _isMonth
                                  // ? _eventDates[index].title
                                  // : getEventForSelectedDayString(
                                  //             _selectedDay.toString())
                                  //         ?.title ??
                                  ''),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
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
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 1,
            color: const Color(0xffCED3DE),
          ),
        ),
        child: Center(
          child: Icon(
            icons,
            color: whiteColor,
          ),
        ));
  }
}
