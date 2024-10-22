import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sydkic/ui_screens/web_chat.dart';
import 'package:sydkic/ui_screens/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui_screens/appointment_page.dart';
import '../ui_screens/contact_list_screen.dart';
import '../ui_screens/home_screen.dart';
import '../utils/constant.dart';

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
  late TabController _tabController;
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
    _tabController = TabController(length: 4, vsync: this);
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = _tabController.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color:Color(0xff121212)),
        padding: const EdgeInsets.only(left: 10,right:10),
        height: 100,
        child: GNav(
          tabBorderRadius: 45,
          selectedIndex: _currentIndex,
          onTabChange: (index){
            _tabController.index=index;
          },
          duration: const Duration(milliseconds: 900), // tab animation duration
          gap: 8, // the tab button gap between icon and text
          color: Colors.grey[800], // unselected icon color
          activeColor: Colors.white, // selected icon and text color
          iconSize: 24, // tab button icon size
          backgroundColor: const Color(0xff121212),
          tabs: const[
            GButton(
              icon: Icons.home,
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
          TabBarView(
            controller: _tabController,
            children: const <Widget>[
              HomePages(),
              ContactListScreen(),
              AppointmentPage(),
              ContactPage(),
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
