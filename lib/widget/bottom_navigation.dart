import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:sydkic/ui_screens/inbox_screen.dart';
import 'package:sydkic/ui_screens/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui_screens/Buckets/campaign_screen.dart';
import '../ui_screens/appointment_screen.dart';
import '../ui_screens/Home/home_screen.dart';
import '../ui_screens/Assistant/assistant_screen.dart';
import '../utils/constant.dart';
import '../utils/string.dart';
import 'drawer_page.dart';

class UserProvider with ChangeNotifier {
  String _name = '';
  bool _isLoggedIn = false;
  String _email = '';
  String _number = '';

  String get name => _name;
  String get email => _email;
  String get number => _number;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name') ?? '';
    _email = prefs.getString('email') ?? '';
    _number = prefs.getString('number') ?? '';
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    // print('name:$_name');
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.setBool('isLoggedIn', false);
    _isLoggedIn = false;
    notifyListeners();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (route) => false,
    );
  }
}

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;

  final List<String> _labels = [
    'Dashboard',
    'Inbox',
    'Appointment',
    'Chatbot',
    'Campaign',
  ];

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.send_outlined,
    Icons.calendar_today_outlined,
    Icons.bookmark_border,
    Icons.campaign_outlined,
  ];

  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the controller to free up resources
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black, // Status bar background color
        statusBarIconBrightness:
            Brightness.light, // Light icons for dark background
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      drawer: const SafeArea(
        child: DrawerScreen(),
      ),
      drawerScrimColor: Colors.transparent,
      backgroundColor: blackColor,
      key: _scaffoldKey,
      // appBar: _currentIndex == 0 && _currentIndex == 1
      //     ? null
      //     : AppBar(
      //         backgroundColor: const Color(0xff000000),
      //         leading: Padding(
      //           padding: const EdgeInsets.only(left: 20),
      //           child: IconButton(
      //             onPressed: () {
      //               _scaffoldKey.currentState?.openDrawer();
      //             },
      //             icon: Icon(
      //               Icons.menu,
      //               size: 30,
      //               color: whiteColor,
      //             ),
      //           ),
      //         ),
      //         title: Text(
      //           _currentIndex == 1
      //               ? MyStrings.inbox
      //               : _currentIndex == 2
      //                   ? ''
      //                   : _currentIndex == 3
      //                       ? 'Chatbot'
      //                       : 'Campaign',
      //           style: const TextStyle(
      //               fontSize: 24,
      //               fontWeight: FontWeight.w600,
      //               color: Colors.white,
      //               fontFamily: MyStrings.outfit),
      //         ),
      //         actions: [
      //           Container(
      //             height: 24,
      //             width: 24,
      //             margin: const EdgeInsets.only(right: 20),
      //             padding: const EdgeInsets.only(top: 2.24, bottom: 2.25),
      //             child: Icon(Icons.cached_outlined, color: whiteColor),
      //           ),
      //         ],
      //       ),
      bottomNavigationBar: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            height: 94,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: blackColor,
                border: Border(
                  top: BorderSide(
                    width: 2,
                    color: primaryColor.withOpacity(1),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: Container(
              height: 76,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Even spacing
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Align items vertically
                children: List.generate(_icons.length, (index) {
                  return GestureDetector(
                    onTap: () => onTabTapped(index),
                    child: _buildTabItem(
                      isSelected: _currentIndex == index,
                      icon: _icons[index],
                      label: _labels[index],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: const <Widget>[
              HomePages(),
              ContactPage(),
              AppointmentPage(),
              AssistantScreen(),
              BucketScreen(),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (route) => false,
    );
  }
}

Widget _buildTabItem({
  required bool isSelected,
  required IconData icon,
  required String label,
}) {
  return Container(
    alignment: Alignment.bottomCenter,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: isSelected ? 0 : 5),
        if (isSelected)
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: blackColor,
              border: GradientBoxBorder(
                width: 2,
                gradient: LinearGradient(
                  colors: [
                    primaryColor,
                    primaryColor,
                    blackColor,
                    blackColor,
                    blackColor,
                    blackColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                size: 24,
                color: const Color(0xff5548B1),
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Icon(
              icon,
              size: 24,
              color: const Color(0xff9490AE),
            ),
          ),
        SizedBox(height: isSelected == true ? 3 : 8),
        SizedBox(
          height: 18,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xff5548B1)
                  : const Color(0xff9490AE),
              fontWeight: FontWeight.w600,
              fontSize: 12,
              fontFamily: MyStrings.outfit,
            ),
          ),
        ),
      ],
    ),
  );
}
