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

  final TextEditingController _controller = TextEditingController();

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
      drawer: const SafeArea(child:DrawerScreen()),
      drawerScrimColor: Colors.transparent,
      backgroundColor: blackColor,
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(144),
        child: Container(
          height: 144,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('asset/image/image.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(
                  _currentIndex == 0 || _currentIndex == 2 ? 0 : 12),
              bottomRight: Radius.circular(
                  _currentIndex == 0 || _currentIndex == 2 ? 0 : 12),
            ),
          ),
          padding:
              const EdgeInsets.only(left: 20, top: 68, bottom: 20, right: 20),
          child: Container(
            height: 46,
            padding: const EdgeInsets.only(
              left: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: blackColor.withOpacity(0.5),
              border: Border.all(color: primaryColor, width: 1),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3), // Light black shadow
                    offset: const Offset(
                        5, 5), // Horizontal and vertical shadow position
                    blurRadius: 10,
                    spreadRadius: 0 // Spread radius
                    ),
              ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 14),
                  child: Icon(Icons.search, color: primaryColor, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 13.5, bottom: 13.5),
                    child: TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: MyStrings.outfit,
                        color: whiteColor,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Name, Number, IG',
                        hintStyle: TextStyle(
                          color: homeTextColor,
                          fontFamily: MyStrings.outfit,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(7),
                  child: Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: GradientBoxBorder(
                        width: 2,
                        gradient: LinearGradient(
                          colors: [
                            whitecolor.withOpacity(1),
                            primaryColor.withOpacity(1),
                          ],
                        ),
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'asset/image/round_profile.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
              AssistantScreen(),
              BucketScreen(),
            ],
          ),
          Positioned(
            bottom:0,
            child:Stack(
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
