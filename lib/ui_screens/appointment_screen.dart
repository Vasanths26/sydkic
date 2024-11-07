import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xff000000),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 76,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Color(0xff1A1C1A)),
              padding:
                  const EdgeInsets.only(top: 24.22, left: 18, right: 16.44),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _focusedDay =
                            DateTime(_focusedDay.year, _focusedDay.month - 1);
                      });
                    },
                    child: forIcon(Icons.arrow_back_ios, 10),
                  ),
                  SizedBox(
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _focusedDay =
                            DateTime(_focusedDay.year, _focusedDay.month + 1);
                      });
                    },
                    child: forIcon(Icons.arrow_forward_ios, 5),
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
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18)),
                  color: Color(0xff1A1C1A),
                ),
                // height: MediaQuery.of(context).size.height - 146,
                padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
                child: Column(
                  children: [
                    AnimatedContainer(
                      alignment: Alignment.centerLeft,
                      duration: const Duration(milliseconds: 300),
                      height: _isExpanded
                          ? MediaQuery.of(context).size.height * 0.37
                          : MediaQuery.of(context).size.height *
                              0.095, // Adjust height as needed
                      width: _isExpanded
                          ? MediaQuery.of(context).size.height * 0.6
                          : MediaQuery.of(context).size.height * 0.6,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.0),
                        color: const Color(0xff1A1C1A),
                      ),
                      margin: EdgeInsets.only(top: _isExpanded ? 10 : 0),
                      child: TableCalendar(
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
                        onFormatChanged: (format) {
                          setState(() {
                            // _calendarFormat = format;
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
                        calendarBuilders: CalendarBuilders(
                          todayBuilder: (context, day, focusedDay) {
                            return Container(
                              height: 40,
                              width: 40, // Add horizontal spacing
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                shape: BoxShape.rectangle,
                                color: whiteColor,
                              ),
                              child: Center(
                                child: Text(day.day.toString(),
                                    style: TextStyle(color: blackColor)),
                              ),
                            );
                          },
                          defaultBuilder: (context, day, focusedDay) {
                            return Container(
                              height: 40,
                              width: 40,
                              margin: const EdgeInsets.all(
                                  8), // Add horizontal spacing
                              child: Center(
                                child: Text(
                                  day.day.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                        calendarStyle: CalendarStyle(
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
                            borderRadius: BorderRadius.circular(15),
                            shape: BoxShape.rectangle,
                            color: whiteColor,
                            // border: Border.all(color: Colors.grey, width: 1),
                          ),
                          selectedTextStyle:
                              const TextStyle(color: Color(0xff121212)),
                          defaultTextStyle:
                              const TextStyle(color: Colors.white),
                          weekendTextStyle:
                              const TextStyle(color: Colors.white),
                          outsideTextStyle: const TextStyle(color: Colors.grey),
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
                          color: const Color(0xff505050),
                        ),
                        margin: const EdgeInsets.only(top: 10),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            ListView.builder(
              itemCount: 2,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff1A1C1A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  padding: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 9.79,
                            width: 9.79,
                            padding: const EdgeInsets.only(
                                top: 16, left: 15, bottom: 20, right: 25),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: const Color(0xffFFFFFF),
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 9.21),
                          const Text(
                            '10.00 - 13.00',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: MyStrings.outfit,
                              letterSpacing: 0.75,
                              color: Color(0xff8B8E8C),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(),
                          const Icon(Icons.more_horiz, color: Color(0xff8B8E8C))
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Personal Meeting',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: MyStrings.outfit,
                          letterSpacing: 0.75,
                          color: Color(0xffFFFFFF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
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
      ),
    );
  }
}
