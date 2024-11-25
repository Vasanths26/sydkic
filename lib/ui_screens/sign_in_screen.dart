import 'dart:convert';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/service.dart';
import '../utils/small_text.dart';
import '../widget/bottom_navigation.dart';
import '../utils/constant.dart';
import '../utils/string.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final CacheManager customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
    ),
  );
  List<String> image = [
    "asset/image/logos_whatsapp-icon.png",
    "asset/image/WhatsApp Business.png",
    "asset/image/instagramLogo.png"
  ];
  bool isloading = false;

  bool isPasswordVisible = false;
  String? errorMessage;

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
      backgroundColor: backgroundcolor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "asset/image/logo.png",
                        height: 30,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        "SYDKIC",
                        style: TextStyle(
                          fontFamily: MyStrings.outfit,
                          fontWeight: FontWeight.w400,
                          color: whiteColor,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome Back to",
                        style: TextStyle(
                          fontFamily: MyStrings.outfit,
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "SYDKIC",
                        style: TextStyle(
                          fontFamily: MyStrings.outfit,
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Securely access your account and enjoy",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: MyStrings.outfit,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                        ),
                      ),
                      Text(
                        "our exclusive feature",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: MyStrings.outfit,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Center(
                            child: Text(
                              errorMessage!,
                              style: const TextStyle(
                                color: Colors.red, // Error text color
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email",
                            style: TextStyle(
                              fontFamily: MyStrings.outfit,
                              fontSize: 16,
                              color: secondaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0), // Adds space on both sides
                            height: 50,
                            decoration: BoxDecoration(
                              color: liteGrey, // Use a slightly darker color
                              borderRadius: BorderRadius.circular(12),
                              border: GradientBoxBorder(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xff5548B1).withOpacity(1),
                                    const Color(0xff5548B1).withOpacity(0.5),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                width: 1,
                              ),
                            ),
                            child: TextFormField(
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelStyle: TextStyle(color: Colors.grey),
                                border: InputBorder
                                    .none, // Removes default border to rely on Container styling
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Password",
                        style: TextStyle(
                          fontFamily: MyStrings.outfit,
                          fontSize: 16,
                          color: secondaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 2), // Adds space on both sides
                        height: 50,
                        decoration: BoxDecoration(
                          color: liteGrey, // Use a slightly darker color
                          borderRadius: BorderRadius.circular(12),
                          border: GradientBoxBorder(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xff5548B1).withOpacity(1),
                                const Color(0xff5548B1).withOpacity(0.5),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            width: 1,
                          ),
                        ),
                        child: TextFormField(
                          cursorColor: whiteColor,
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          decoration: InputDecoration(
                            border: InputBorder
                                .none, // Removes the underline border

                            labelStyle: const TextStyle(color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors
                                .white, // Set your desired text color here
                            fontSize:
                                17, // Optional: Set the font size or other text properties
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            // Fluttertoast.showToast(
                            //     msg: "Both email and password are required.");
                            setState(() {
                              errorMessage =
                                  'Both email and password are required';
                            });
                          } else {
                            bool isLoginSuccessful = await _logIn(
                              context,
                              emailController.text,
                              passwordController.text,
                            );

                            if (!isLoginSuccessful) {
                              // Fluttertoast.showToast(
                              //     msg: "Incorrect email or password.");
                              setState(() {
                                errorMessage = 'Incorrect email or password';
                              });
                            }
                          }
                        },
                        child: Center(
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: whiteColor,
                            ),
                            child: Center(
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      color: primaryColor,
                                    )
                                  :  Text(
                                      "Sign in",
                                      style: TextStyle(
                                        fontFamily: MyStrings.outfit,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Divider(
                              color: signinorColor, // Color of the divider
                              thickness: 0.5, // Thickness of the divider
                              endIndent: 8, // Space at the end of the divider
                            ),
                          ),
                          SmallText(
                            text: MyStrings.or,
                            size: 16,
                            color: secondaryColor,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.center,
                            fontFamily: MyStrings.outfit,
                          ),
                          Expanded(
                            child: Divider(
                              color: signinorColor,
                              thickness: 0.5,
                              indent: 8, // Space at the start of the divider
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: liteGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 25,
                              width: 25,
                              child: Center(
                                child: Image.asset(
                                  "asset/image/google trasprant.png",
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Center(
                              child: SmallText(
                                color: secondaryColor,
                                text: MyStrings.continueWithGoogle,
                                size: 16,
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.center,
                                fontFamily: MyStrings.outfit,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: liteGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 25,
                              width: 25,
                              child: Center(
                                child: Image.asset(
                                  "asset/image/facebook.png",
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Center(
                              child: SmallText(
                                color: secondaryColor,
                                text: MyStrings.continueWithFaceBook,
                                size: 16,
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.center,
                                fontFamily: MyStrings.outfit,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _logIn(
      BuildContext context, String email, String password) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Webservice().callLoginService(
          email: email, password: password, showSnackBar: (SnackBar) {});

      if (response != null && response.status == "success") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);
        await prefs.setString('name', response.user!.name.toString());
        await prefs.setString('number', response.user!.phone.toString());
        await prefs.setString(
            'authorization', response.authorization?.token ?? '');
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString(
            'loginDate', DateFormat("yyyy-MM-dd").format(DateTime.now()));

        // Cache user profile data
        final userData = {
          'email': email,
          'name': response.user!.name.toString(),
          'authorization': response.authorization?.token ?? '',
          'loginDate': DateFormat("yyyy-MM-dd").format(DateTime.now()),
        };
        final dataBytes =
            utf8.encode(jsonEncode(userData)); // Convert user data to bytes
        await customCacheManager.putFile(
          'userProfileData',
          dataBytes, // Data to be cached as bytes
          fileExtension: 'json', // or any other relevant extension
        );

        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavigationScreen(),
            ),
          );
        }
        return true;
      } else {
        // Fluttertoast.showToast(msg: "Incorrect email or password.");
        return false;
      }
    } catch (e) {
      // Fluttertoast.showToast(msg: "An error occurred");
      if (kDebugMode) {
        print(e);
      }
      return false;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
