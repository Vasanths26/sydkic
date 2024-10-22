import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../utils/constant.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/string.dart';
import '../widget/bottom_navigation.dart';
import '../widget/welocmescreen.dart';

class SignInProvider with ChangeNotifier {
  bool _isSignedIn = false;

  bool get isSignedIn => _isSignedIn;

  SignInProvider() {
    checkSignInUser();
  }

  Future<void> checkSignInUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

    _isSignedIn = isLoggedIn;
    notifyListeners();
  }

  Future<void> signIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true);
    _isSignedIn = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
    _isSignedIn = false;
    notifyListeners();
  }
}

class FadeInAndSlide extends StatefulWidget {
  const FadeInAndSlide({super.key});

  @override
  State<FadeInAndSlide> createState() => _FadeInAndSlideState();
}

class _FadeInAndSlideState extends State<FadeInAndSlide> {
  String logo = "asset/image/4.png";
  String logoText = "SYDKIC";
  bool isDone = false;
  bool? value; // Use nullable bool
  final customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
    ),
  );

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  // Helper function to handle async initialization
  void _initializeState() async {
    bool cacheValid = await _checkCacheExpiration();
    setState(() {
      value = cacheValid; // Update state with cache check result
    });
  }

  Future<bool> _checkCacheExpiration() async {
    final cacheFile = await customCacheManager.getFileFromCache('userProfileData');

    if (cacheFile != null) {
      final file = cacheFile.file;
      final lastModified = await file.lastModified();
      final now = DateTime.now();
      final difference = now.difference(lastModified).inDays;

      return difference < 7; // Return true if cache is still valid, false otherwise
    } else {
      return false; // No cache data available
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignInProvider(),
      child: Consumer<SignInProvider>(builder: (context, provider, _) {
        return Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              isDone
                  ? Center(
                child: Text(
                  logoText,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,fontFamily: MyStrings.outfit,letterSpacing: 1,
                      color: primaryColor),
                ),
              )
                  .animate()
                  .fadeIn(duration: 1000.ms)
                  .then(delay: 600.ms)
                  .slideX(begin: 0)
                  .then(delay: 1000.ms)
                  : Container(),
              Center(
                  child: Image.asset(
                    logo,
                    width: 50,
                  ))
                  .animate()
                  .fadeIn(duration: 1000.ms)
                  .then(delay: 1200.ms)
                  .slideX(end: -0.17, duration: 2000.ms)
                  .callback(
                  duration: 600.ms,
                  callback: (_) {
                    setState(() {
                      isDone = true;
                    });
                  })
                  .then(delay: 1500.ms)
                  .callback(callback: (_) {
                if (provider.isSignedIn) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNavigationScreen(),
                      ),
                    );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                  );
                }
              }),
            ],
          ),
        );
      }),
    );
  }
}
