import 'package:flutter/material.dart';
import '../ui_screens/sign_in_screen.dart';
import '../utils/constant.dart';
import '../utils/string.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color:Color(0xff121212),
          // gradient: LinearGradient(colors: [Color(0xff5548B1),Color(0xffE8E4FF)],begin: Alignment.topCenter,end:Alignment.bottomCenter),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:45,left:41.5,right:41.5),
                child: Image.asset("asset/image/header-image.png",
                    height: 346.01,width: 310,),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 424,
                  decoration: const BoxDecoration(
                    color: Color(0xff121212),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  padding: const EdgeInsets.only(top:61),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left:47),
                        child: Text("Welcome to",
                            style: TextStyle(
                                fontFamily: MyStrings.outfit,
                                color: Colors.grey,
                                fontSize: 25,
                                fontWeight: FontWeight.w600)),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left:47),
                        child: Text("Sydkic",
                            style: TextStyle(
                                fontFamily: MyStrings.outfit,
                                color: Color(0xffFFFFFF),
                                fontSize: 25,
                                fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        width: 234,
                        padding: const EdgeInsets.only(left:47),
                        child: const Text(
                          "Here some contents based \non your preference",
                          maxLines:2,
                          style: TextStyle(
                              fontFamily: MyStrings.outfit,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                      ),
                      // const Text(
                      //   "on your preference",
                      //   style: TextStyle(
                      //       fontFamily: MyStrings.outfit,
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.w400,
                      //       color: Colors.grey),
                      // ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          margin: const EdgeInsets.only(left:29,right:29,top:40),
                          decoration: BoxDecoration(
                              color: blackColor,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: const Color(0xffFFFFFF))),
                          child: Center(
                              child: Text(
                            "Let’s Get Started",
                            style: TextStyle(
                                fontFamily: MyStrings.outfit,
                                color: whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
