import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sydkic/ui_screens/Home/profile_screen.dart';
import '../../utils/constant.dart';
import '../../utils/string.dart';
import 'package:http/http.dart' as http;
import '../../../model/dashboard_model.dart';
import '../../../utils/api_constant.dart';
import 'package:quickalert/quickalert.dart';
import '../../widget/bottom_navigation.dart';

class HomePageProvider extends ChangeNotifier {
  bool _isloading = false;
  bool get isloading => _isloading;

  DashboardDetails? _dashboardDetails;
  DashboardDetails get dashboardDetails => _dashboardDetails!;
  Future<void> fetchDashboardDetails() async {
    _isloading = true;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('authorization');

    try {
      var response = await http.get(
        Uri.parse(ApiConstants.getDashboardDetails),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        DashboardDetails dashboardDetails = DashboardDetails.fromJson(jsonData);
        _dashboardDetails = dashboardDetails;
      } else {
        if (kDebugMode) {
          print('Failed to fetch dashboard: ${response.statusCode}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching dashboard: $error');
      }
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }
}

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  List<IconData> icons = [
    Icons.card_membership_outlined,
    Icons.person_outline,
    Icons.help_outline_outlined,
    Icons.more_horiz
  ];
  List<String> text = ['Subscription', 'Profile', 'Support', 'More'];

  List<IconData> icons1 = [
    Icons.message,
    Icons.forum_outlined,
    Icons.smart_toy_outlined,
    Icons.campaign_outlined
  ];
  List<String> text1 = ['1000', '500', '05', '03'];
  List<String> text2 = [
    'Total Messages',
    'Total Conversation',
    'Active Assistant',
    'Active Campaigns'
  ];

  List<Color> color = [
    const Color(0xffCAE9FF),
    const Color(0xffD3CAFF),
    const Color(0xffDAF3F1),
    const Color(0xffFFE2CB)
  ];
  List<Color> color1 = [
    const Color(0xff58AFEE),
    const Color(0xff7A63EC),
    const Color(0xff00A397),
    const Color(0xffFC923C)
  ];
  List<Color> color2 = [
    const Color(0xffE0F2FF),
    const Color(0xffE8E4FF),
    const Color(0xffE6FFF1),
    const Color(0xffFFF3E5),
  ];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePageProvider()..fetchDashboardDetails(),
      child: Consumer<HomePageProvider>(builder: (context, provider, _) {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.black, // Status bar background color
            statusBarIconBrightness:
                Brightness.light, // Light icons for dark background
          ),
        );
        return provider.isloading == true
            ? Scaffold(
                backgroundColor: const Color(0xff000000),
                body: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: const Color(0xff000000),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(top: 34, left: 20, right: 20),
                        height: 220,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: const Color(0xff1A1C1A),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 16,
                              child: Text(
                                'Active Devices',
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 13,
                                    fontFamily: MyStrings.outfit,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            SizedBox(
                              height: 30,
                              child: Text(
                                  '${provider.dashboardDetails.activeDevice}/${provider.dashboardDetails.totalDevice}',
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 24,
                                      fontFamily: MyStrings.outfit,
                                      fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 32, right: 32),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.5,
                                  color: const Color(0xffFFFFFF),
                                ),
                              ),
                            ),
                            Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(
                                  top: 23, left: 27, right: 27, bottom: 30),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: contain(
                                        0,
                                        Icons.card_membership_outlined,
                                        'Subscription'),
                                  ),
                                  const SizedBox(width: 31),
                                  Expanded(
                                    child: contain(
                                        1, Icons.person_outline, 'Profile'),
                                  ),
                                  const SizedBox(width: 31),
                                  Expanded(
                                      child: contain(
                                          2,
                                          Icons.help_outline_rounded,
                                          'Support')),
                                  const SizedBox(width: 31),
                                  Expanded(
                                      child:
                                          contain(3, Icons.more_horiz, 'More')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 468,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        margin: const EdgeInsets.only(top: 15),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18)),
                            color: Color(0xff000000)),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 19,
                                  mainAxisSpacing: 20,
                                  crossAxisCount: 2),
                          itemCount: icons1.length,
                          itemBuilder: (context, index) {
                            final texts = [
                              provider._dashboardDetails!.totalMessages,
                              provider._dashboardDetails!.totalConversations,
                              provider._dashboardDetails!.activeAssistants,
                              provider._dashboardDetails!.activeCampaigns
                            ];
                            return Container(
                              height: 160,
                              width: 167,
                              padding: const EdgeInsets.only(
                                top: 20,
                                left: 20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: const Color(0xff1A1C1A),
                                // border: Border.all(
                                //     width: 1,
                                //     color: const Color(0xffF0F0F0))
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 45,
                                    width: 45,
                                    padding: const EdgeInsets.only(
                                        top: 10.5,
                                        left: 10,
                                        right: 11,
                                        bottom: 10.5),
                                    margin: const EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFFFFFF),
                                      borderRadius: BorderRadius.circular(18),
                                      // border: Border.all(
                                      //   width: 1,
                                      //   color: color[index],
                                      // ),
                                    ),
                                    child: Icon(
                                      icons1[index],
                                      color: const Color(0xff121212),
                                    ),
                                  ),
                                  Text(
                                    '${texts[index]}',
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 20,
                                        fontFamily: MyStrings.outfit,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    text2[index],
                                    style: const TextStyle(
                                        color: Color(0xff8B8E8C),
                                        fontSize: 16,
                                        fontFamily: MyStrings.outfit,
                                        fontWeight: FontWeight.w500),
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
      }),
    );
  }

  Widget contain(int index, IconData icon, String text) {
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ProfilePage()));
        }
        if (index == 3) {
          _showAddServiceDialog(context);
        }
      },
      child: SizedBox(
        height: 80,
        // width: 58,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              // margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: whiteColor),
              child: Icon(
                icon,
                color: const Color(0xff121212),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                // height: 12,
                // width:58,
                child: Center(
                  child: Text(
                    text,
                    maxLines: 1,
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        fontFamily: MyStrings.outfit),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddServiceDialog(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Are you sure you want to exit?',
      title: 'Logout',
      confirmBtnText: 'Logout',
      cancelBtnText: 'Cancel',
      confirmBtnColor: primaryColor,
      confirmBtnTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: MyStrings.outfit,
      ),
      cancelBtnTextStyle: TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.bold,
        fontFamily: MyStrings.outfit,
      ),
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
        Provider.of<UserProvider>(context, listen: false).logout(context);
      },
      onCancelBtnTap: () {
        Navigator.of(context).pop();
      },
      backgroundColor: Colors.white,
      borderRadius: 20,
    );
  }
}
