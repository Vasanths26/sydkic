import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import '../utils/constant.dart';
import '../utils/string.dart';
import 'bottom_navigation.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider()..loadUser(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width / 1.1,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xffFFFFFF), Color(0xffC8C8C8)],
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(34),
            bottomRight: Radius.circular(34),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<UserProvider>(builder: (context, provider, _) {
                return Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          cacheManager: customCacheManager,
                          imageUrl:
                              "https://as1.ftcdn.net/v2/jpg/03/39/45/96/1000_F_339459697_XAFacNQmwnvJRqe1Fe9VOptPWMUxlZP8.jpg",
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          provider.name,
                          style: TextStyle(
                              color: blackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: MyStrings.outfit),
                        ),
                        Text(
                          provider.email,
                          style: const TextStyle(
                              color: Color(0xff8B8E8C),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: MyStrings.outfit),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        buildCategory(Icons.dashboard_outlined, "Dashboard"),
                        const SizedBox(height: 10),
                        buildCategory(Icons.contacts_outlined, "Contacts"),
                        const SizedBox(height: 10),
                        buildCategory(Icons.podcasts_outlined, "BoardCast"),
                        const SizedBox(height: 10),
                        buildCategory(Icons.smart_toy_outlined, "Assistant"),
                      ],
                    ),
                  ),

                  // Divider between the first and second sections
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),

                  // Replace Spacer with a SizedBox with fixed height
                  const SizedBox(height: 20), // Adjust height as needed

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: buildCategory(
                            Icons.account_circle_outlined,
                            "My Profile",
                          ),
                        ),
                        buildCategory(
                            Icons.perm_contact_cal_sharp, "Import Contact"),
                        buildCategory(
                            Icons.business_center_outlined, "Subscription"),
                        buildCategory(Icons.code_outlined, "Api Config"),
                        buildCategory(Icons.support_outlined, "Support"),
                      ],
                    ),
                  ),

                  // Another Divider before the logout button
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  Consumer<UserProvider>(
                    builder: (context, provider, _) {
                      return GestureDetector(
                        onTap: () {
                          provider.logout(context);
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: blackColor,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: MyStrings.outfit,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategory(IconData iconData, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Icon(
              iconData,
              color: const Color(0xff1C1B1F),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: MyStrings.outfit,
                  color: blackColor,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    );
  }
}
