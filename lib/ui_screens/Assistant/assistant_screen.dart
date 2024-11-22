import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:sydkic/ui_screens/Assistant/assistant.dart';
import '../../model/assistant_model.dart';
import '../../utils/api_constant.dart';
import '../../utils/constant.dart';
import '../../utils/string.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AssistantProvider extends ChangeNotifier {
  void setIsSelected(int index) {
    _isSelected = index;
    notifyListeners();
  }

  int _isSelected = 0;
  bool _isloading = false;
  List<AssistantList> _assistantList = [];
  List<AssistantList> _originalAssistantList = [];
  List<AssistantList> get assistantList => _assistantList;
  List<AssistantList> get originalAssistantList => _originalAssistantList;
  int get isSelected => _isSelected;
  bool get isloading => _isloading;
  void setAssistantList(List<AssistantList> assistants) {
    _assistantList = assistants;
    _originalAssistantList = List.from(assistants);
    notifyListeners();
  }

  Future<void> fetchAssistantList() async {
    _isloading = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('authorization');
    if (kDebugMode) {
      print("access token $token");
    }
    try {
      var response = await http.get(
        Uri.parse(ApiConstants.getAssistantList),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        AssistantModel assistantListModel = AssistantModel.fromJson(jsonData);
        setAssistantList(assistantListModel.assistantList ?? []);
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
      _isloading = false;
      notifyListeners();
    }
  }
}

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final List<Map<String, dynamic>> groupList = [
    {'name': 'Cricket Group', 'isNavigable': true},
    {'name': 'Trip Plan', 'isNavigable': false},
    {'name': 'Girl Friends', 'isNavigable': false},
    {'name': 'Test Assistant1', 'isNavigable': false},
  ];
  final List<bool> switchValue = [true, true, false, true];
  // final TextEditingController _controller = TextEditingController();

  List<bool> switchStates = List.generate(10, (index) => false);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black, // Status bar background color
        statusBarIconBrightness:
            Brightness.dark, // Light icons for dark background
      ),
    );
    return Scaffold(
      backgroundColor: blackColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 22),
        child: ListView.builder(
          itemCount: groupList.length,
          itemBuilder: (context, index) {
            final groupName = groupList[index]['name'];
            final isNavigable = groupList[index]['isNavigable'];

            return Column(
              children: [
                group(groupName, isNavigable, switchValue[index], index),
                index == groupList.length - 1
                    ? Container()
                    : const SizedBox(height: 15),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget group(String text, bool value, bool switchValue, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupAssistant(topic: text),
          ),
        );
      },
      child: Container(
        height: 120,
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
          color: const Color(0xff1A1C1A),
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  height: 20,
                  child: Text(
                    text,
                    style: TextStyle(
                        fontSize: 16,
                        color: homeTextColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: MyStrings.outfit),
                  ),
                ),
                const SizedBox(height: 33),
                Stack(
                  children: [
                    Container(
                      height: 32,
                      width: 128,
                      decoration: const BoxDecoration(),
                      alignment: Alignment.centerLeft,
                    ),
                    imagePosition(0, false),
                    imagePosition(24, false),
                    imagePosition(48, false),
                    imagePosition(72, false),
                    value ? imagePosition(96, true) : const SizedBox(),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                Container(
                  height: 32,
                  width: 32,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: assistantImageColor,
                  ),
                  child: SizedBox(
                    height: 16,
                    width: 16,
                    child: Icon(
                      index != 1 ? Icons.lock : Icons.lock_open_outlined,
                      color: primaryColor,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                Container(
                  height: 18,
                  width: 32,
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: activeDeviceTextColor,
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
                          switchStates[index] =
                              value; // Update the specific switch state
                        });
                      },
                      trackOutlineColor:
                          WidgetStatePropertyAll(Colors.transparent),
                      inactiveTrackColor: whiteColor,
                      inactiveThumbColor: primaryColor,
                      activeTrackColor: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget imagePosition(double left, bool value) {
    return Positioned(
      left: left,
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xffFFFFFF),
          border: Border.all(color: const Color(0xffFFFFFF), width: 1.5),
        ),
        child: ClipOval(
          child: value == false
              ? Image.asset('asset/image/round_profile.webp', fit: BoxFit.cover)
              : const Center(
                  child: SizedBox(
                    height: 13,
                    // width: 23,
                    child: Text(
                      '+245',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: MyStrings.outfit,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff5548B1),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
