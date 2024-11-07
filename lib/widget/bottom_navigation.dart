import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sydkic/ui_screens/web_chat.dart';
import 'package:sydkic/ui_screens/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui_screens/appointment_screen.dart';
import '../ui_screens/home_screen.dart';
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
  List<IconData> icons = [
    Icons.home_outlined,
    Icons.chrome_reader_mode_outlined,
    Icons.send_outlined,
    Icons.person_outline
  ];

  List<String> text = ['Dashboard', 'Contact', 'Appointment', 'Assistent'];
  int _currentIndex = 0;

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
      backgroundColor: whiteColor,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: _currentIndex == 2
            ? const Color(0xff1A1C1A)
            : const Color(0xff121212),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(
              Icons.menu,
              size: 30,
              color: whiteColor,
            ),
          ),
        ),
        title: Text(
            _currentIndex == 0
                ? 'Dashboard'
                : _currentIndex == 1
                    ? MyStrings.inbox
                    : _currentIndex == 2
                        ? 'Appointment'
                        : 'Assistant',
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: MyStrings.outfit)),
        actions: [
          Container(
            height: 24,
            width: 24,
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.only(top: 2.24, bottom: 2.25),
            child: Icon(Icons.cached_outlined, color: whiteColor),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Color(0xff121212)),
        padding: const EdgeInsets.only(left: 10, right: 10),
        height: 80,
        child: GNav(
          tabBorderRadius: 45,
          selectedIndex: _currentIndex,
          onTabChange: (index) {
            onTabTapped(index);
          },
          duration: const Duration(milliseconds: 900), // tab animation duration
          gap: 8, // the tab button gap between icon and text
          color: Colors.grey[800], // unselected icon color
          activeColor: Colors.white, // selected icon and text color
          iconSize: 24, // tab button icon size
          backgroundColor: const Color(0xff121212),
          tabs: const [
            GButton(
              icon: Icons.home_filled,
              // text: 'Dashboard',
            ),
            GButton(
              icon: Icons.chrome_reader_mode_outlined,
              // text: 'Contact',
            ),
            GButton(
              icon: Icons.send_outlined,
              // text: 'Appointment',
            ),
            GButton(
              icon: Icons.person_outlined,
              // text: 'Web chat',
            )
          ],
        ),
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
              AssistantScreen()
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
