import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sydkic/ui_screens/Home/profile_screen.dart';
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

  List<String> image = [
    'asset/image/instagram.png',
    'asset/image/whatsapp-logo.png',
    'asset/image/pngwing.png',
    'asset/image/Component.png',
    'asset/image/pngwing.png',
    'asset/image/Component.png',
  ];

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePageProvider()..fetchDashboardDetails(),
      child: Consumer<HomePageProvider>(
        builder: (context, provider, _) {
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
                          height: 240,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('asset/image/image.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          padding: const EdgeInsets.only(
                              left: 20, top: 68, bottom: 15),
                          child: Column(
                            children: [
                              Container(
                                height: 46,
                                margin: const EdgeInsets.only(right: 20),
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 7,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  color:
                                      const Color(0xff000000).withOpacity(0.5),
                                  border: Border.all(
                                      color: const Color(0xff5548B1), width: 1),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(top: 14, bottom: 14),
                                      child: Icon(Icons.search,
                                          color: Color(0xff5548B1), size: 18),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 13.5, bottom: 13.5),
                                        child: TextFormField(
                                          controller: _controller,
                                          keyboardType: TextInputType.multiline,
                                          // maxLines: 6,
                                          // minLines: 1,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: MyStrings.outfit,
                                            color: whiteColor,
                                          ),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Search Name, Number, IG',
                                            hintStyle: TextStyle(
                                                color: Color(0xff9490AE),
                                                fontFamily: MyStrings.outfit,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      height: 32,
                                      width: 32,
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xffFFFFFF)
                                                .withOpacity(1),
                                            const Color(0xff5548B1)
                                                .withOpacity(1),
                                          ],
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                            'asset/image/round_profile.webp',
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      height: 16,
                                      child: Text(
                                        'Active Devices',
                                        style: TextStyle(
                                            color: Color(0xff9490AE),
                                            fontSize: 13,
                                            fontFamily: MyStrings.outfit,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      height: 20,
                                      margin: const EdgeInsets.only(right: 25),
                                      child: Text(
                                        '${provider._dashboardDetails?.activeDevice}/${provider._dashboardDetails?.totalDevice}',
                                        style: const TextStyle(
                                            color: Color(0xffE0DCFF),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: MyStrings.outfit),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                height: 45,
                                // decoration: const BoxDecoration(
                                //   boxShadow: [
                                //     BoxShadow(
                                //         color: Color(0xff5548B1),
                                //         blurRadius: 10,
                                //         offset: Offset(4, 4),
                                //         spreadRadius: 5),
                                //     BoxShadow(
                                //         color: Color(0xff000000),
                                //         blurRadius: 4,
                                //         offset: Offset(0, 0),
                                //         spreadRadius: 5),
                                //   ],
                                // ),
                                margin: const EdgeInsets.only(left: 5),
                                alignment: Alignment.bottomCenter,
                                child: ListView.builder(
                                  itemCount: image.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        Container(
                                          height: index == 1 ? 45 : 40,
                                          width: index == 1 ? 50 : 40,
                                          margin: EdgeInsets.only(
                                              right: 30,
                                              top: index == 1 ? 0 : 5),
                                          padding: EdgeInsets.only(
                                              top: index == 1 ? 5 : 0,
                                              right: index == 1 ? 10 : 0),
                                          child: Image.asset(
                                            image[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          left: 30,
                                          bottom: 25,
                                          child: index == 1
                                              ? Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: whiteColor),
                                                  child: const Center(
                                                    child: Text(
                                                      '2',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff5548B1),
                                                          fontFamily:
                                                              MyStrings.outfit,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // height: 378,
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 21),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // First Row
                              Row(
                                // mainAxisAlignment:
                                // MainAxisAlignment.spaceBetween,
                                children: [
                                  buildGridItem(
                                    icon: icons1[0],
                                    value:
                                        '${provider._dashboardDetails!.totalMessages}',
                                    label: text2[0],
                                  ),
                                  const SizedBox(width: 15),
                                  buildGridItem(
                                    icon: icons1[1],
                                    value:
                                        '${provider._dashboardDetails!.totalConversations}',
                                    label: text2[1],
                                  ),
                                ],
                              ),
                              // Second Row
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  buildGridItem(
                                    icon: icons1[2],
                                    value:
                                        '${provider._dashboardDetails!.activeAssistants}',
                                    label: text2[2],
                                  ),
                                  const SizedBox(width: 15),
                                  buildGridItem(
                                    icon: icons1[3],
                                    value:
                                        '${provider._dashboardDetails!.activeCampaigns}',
                                    label: text2[3],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          height: 16,
                          padding: const EdgeInsets.only(left: 20, right: 22),
                          child: const Row(
                            children: [
                              Text(
                                'Recent Chat',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 13,
                                  fontFamily: MyStrings.outfit,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff9490AE),
                                ),
                              ),
                              Spacer(),
                              Text(
                                'See all',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 13,
                                  fontFamily: MyStrings.outfit,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffD9D3FF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                // width: MediaQuery.of(context).size.width * 0.5,
                                child: recentChat(),
                              ),
                              Container(
                                height: 15,
                                margin:
                                    const EdgeInsets.only(left: 24, right: 24),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: const Color(0xff8B8E8C),
                                  ),
                                ),
                              ),
                              SizedBox(
                                // width: MediaQuery.of(context).size.width / 2,
                                child: recentChat(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget recentChat() {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              height: 50,
              width: 51,
              padding: const EdgeInsets.only(top: 5, right: 6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'asset/image/round_profile.webp',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 31,
              bottom: 30,
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: whiteColor,
                  border: Border.all(
                    width: 1,
                    color: const Color(0xff000000),
                  ),
                ),
                child: const Center(
                  child: Text(
                    '12',
                    style: TextStyle(
                      fontSize: 8,
                      fontFamily: MyStrings.outfit,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff5548B1),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        const Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 91,
                child: Text(
                  'Bessie Cooper',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: MyStrings.outfit,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff9490AE),
                  ),
                ),
              ),
              Text(
                '1h ago',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: MyStrings.outfit,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff8B8E8C),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildGridItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      // height: 160,
      width: MediaQuery.of(context).size.width * 0.43,
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xff1A1C1A).withOpacity(0.3),
        border: Border.all(
          width: 1,
          color: const Color(0xff5548B1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 45,
            width: 45,
            padding: const EdgeInsets.all(10.5),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: const Color(0xff000000),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 1,
                color: const Color(0xff5548B1),
              ),
            ),
            child: Icon(
              icon,
              color: const Color(0xff5548B1),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xffE0DCFF),
              fontSize: 20,
              fontFamily: MyStrings.outfit,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xff9490AE),
              fontSize: 16,
              fontFamily: MyStrings.outfit,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
