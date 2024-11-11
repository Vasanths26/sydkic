import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;
import 'package:sydkic/utils/constant.dart';
import '../utils/string.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/contact_assistent_model.dart';
import '../model/contactlist_model.dart';
import '../utils/api_constant.dart';
import '../Chat/chat_screen.dart';
import 'contact_assitent.dart';

class WebChatProvider with ChangeNotifier {
  List<UserContacts> _userContacts = [];
  List<UserContacts> _filteredContacts = [];
  List<ContactAssistant> _contactAssistant = [];
  bool _isLoading = false;
  String _searchQuery = '';
  int _currentIndex = -1;
  int _selectedIndex = 0;
  DateTime? date;

  List<UserContacts> get userContacts => _filteredContacts;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  int get currentIndex => _currentIndex;
  int get selectedIndex => _selectedIndex;
  DateTime? get dateTime => date;

  void selected(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void current(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterContacts();
    notifyListeners();
  }

  Future<void> fetchContactDetails() async {
    _isLoading = true;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('authorization');

    try {
      var response = await http.get(
        Uri.parse(ApiConstants.getContactDatas),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        ContactModel contactModel = ContactModel.fromJson(jsonData);
        _userContacts = contactModel.userContacts ?? [];
        _filterContacts();
      } else {
        if (kDebugMode) {
          print('Failed to fetch contacts: ${response.statusCode}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching contacts: $error');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _filterContacts() {
    _filteredContacts = _userContacts.where((contact) {
      final name = contact.name?.toLowerCase() ?? '';
      final phone = contact.phone?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || phone.contains(query);
    }).toList();
  }

  Future<List<ContactAssistant>> fetchContactAssistent(int contactid) async {
    _isLoading = true;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('authorization');

    try {
      var response = await http.get(
        Uri.parse('${ApiConstants.getContactAssistent}/$contactid'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        ContactAssistentModel contactAssistentModel =
            ContactAssistentModel.fromJson(jsonData);
        _contactAssistant = contactAssistentModel.contactAssistant!;
      } else {
        if (kDebugMode) {
          print('Failed to fetch assistant: ${response.statusCode}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching assistant: $error');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return _contactAssistant;
  }

  List<UserContacts> getMatchedContacts(
      WebChatProvider webChatProvider,
      String assistantId,
      String selectedAssistantName,
      String selectedAssistantID) {
    List<UserContacts> userContacts = webChatProvider.userContacts;
    return userContacts.where((contact) {
      return contact.assistantContact?.assistantName == selectedAssistantName &&
          contact.assistantContact?.status == "Active";
    }).toList();
  }

  double getTextWidth(String text, TextStyle style) {
    // Use TextPainter to calculate the width of the text
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: ui.TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.size.width;
  }

  double namelength(String? name, double containerWidth, {String? number}) {
    // Use the number if name is null
    final displayName = name ?? number;
    if (displayName == null || displayName.isEmpty) {
      return containerWidth;
    }
    if (containerWidth < 100) {
      return containerWidth - 10;
    }
    // if (containerWidth < 100) {
    //   return containerWidth - 10;
    // }
    return containerWidth;
  }
}

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  // List<bool> switchStates = List.generate(10, (index) => false);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WebChatProvider>(context, listen: false)
          .fetchContactDetails();
    });
    Provider.of<WebChatProvider>(context, listen: false)._isLoading;
  }

  void refreshContacts() {
    Provider.of<WebChatProvider>(context, listen: false).fetchContactDetails();
  }

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<WebChatProvider>(
        builder: (context, webChatProvider, child) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.black, // Status bar background color
          statusBarIconBrightness:
              Brightness.light, // Light icons for dark background
        ),
      );
      return webChatProvider.isLoading
          ? Scaffold(
              backgroundColor: const Color(0xff000000),
              body: Shimmer.fromColors(
                baseColor: const Color(0xff1A1C1A),
                highlightColor: Colors.grey[700]!,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: webChatProvider.userContacts.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            left: 20, top: 12.5, bottom: 12.5, right: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xff1A1C1A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
              ),
            )
          : Scaffold(
              backgroundColor: const Color(0xff000000),
              body: ListView.builder(
                  shrinkWrap: true,
                  itemCount: webChatProvider.userContacts.length,
                  itemBuilder: (context, index) {
                    UserContacts userContact =
                        webChatProvider.userContacts[index];
                    return Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(
                          left: 20, top: 12.5, bottom: 12.5, right: 20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ChatScreen(),
                                ),
                              );
                            },
                            child: SizedBox(
                              child: Row(
                                children: [
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: userContact.profileImg != null &&
                                              userContact.profileImg!.isNotEmpty
                                          ? Colors.white
                                          : const Color(0xffFFFFFF),
                                    ),
                                    child: userContact.profileImg != null &&
                                            userContact.profileImg!.isNotEmpty
                                        ? ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: userContact.profileImg!,
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Center(
                                                child: Text(
                                                  userContact.name != null &&
                                                          userContact
                                                              .name!.isNotEmpty
                                                      ? userContact.name!
                                                          .substring(0, 1)
                                                          .toUpperCase() // First letter of the name
                                                      : "+${userContact.phone!.substring(0, 2)}", // + and first two digits of phone number
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors
                                                          .black, // Text color
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          MyStrings.outfit),
                                                ),
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Center(
                                            child: Text(
                                              userContact.name != null &&
                                                      userContact
                                                          .name!.isNotEmpty
                                                  ? userContact.name!
                                                      .substring(0, 1)
                                                      .toUpperCase() // First letter of the name
                                                  : "+${userContact.phone!.substring(0, 2)}", // + and first two digits of phone number
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors
                                                      .black, // Text color
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: MyStrings.outfit),
                                            ),
                                          ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 24,
                                            alignment: Alignment.centerLeft,
                                            // width: containerWidth,
                                            // width: webChatProvider
                                            //     .namelength(
                                            //         userContact.name,
                                            //         containerWidth,
                                            //         number: userContact
                                            //             .phone),
                                            child: Text(
                                              userContact.name ??
                                                  '+${userContact.phone ?? 'No Phone'}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                  fontFamily: MyStrings.outfit),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          index >= 1 && index <= 10
                                              ? Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color:
                                                              Color(0xffFFFFFF),
                                                          shape:
                                                              BoxShape.circle),
                                                  child: Center(
                                                    child: Text(
                                                      '55',
                                                      style: TextStyle(
                                                        color: blackColor,
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          logo('asset/image/whatsapp-logo.png'),
                                          const SizedBox(width: 5),
                                          logo(
                                              'asset/image/instagram-device 1.png'),
                                          const SizedBox(width: 5),
                                          logo(
                                              'asset/image/envelope-device 1.png'),
                                          index == 3
                                              ? logo(
                                                  'asset/image/web-chat 1.png')
                                              : const SizedBox()
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 18,
                                  width: 32,
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xffE0DCFF),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: SwitchTheme(
                                    data: SwitchThemeData(
                                      thumbColor: WidgetStateProperty
                                          .resolveWith<Color?>((states) {
                                        if (states
                                            .contains(WidgetState.selected)) {
                                          return const Color(
                                              0xffFFFFFF); // Active thumb color
                                        }
                                        return const Color(
                                            0xff121212); // Inactive thumb color
                                      }),
                                      trackColor: WidgetStateProperty
                                          .resolveWith<Color?>((states) {
                                        if (states
                                            .contains(WidgetState.selected)) {
                                          return const Color(
                                              0xff121212); // Active track color
                                        }
                                        return const Color(
                                            0xffF0F2F5); // Inactive track color
                                      }),
                                      // Custom size: active thumb will appear smaller
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Transform.scale(
                                      scale: 0.75,
                                      child: Switch(
                                        value: userContact.assistantContact !=
                                                    null &&
                                                userContact.assistantContact
                                                        ?.status ==
                                                    "Active"
                                            ? true
                                            : false,
                                        onChanged: (value) {
                                          showContactAssistantModal(context,
                                              userContact.id, refreshContacts);
                                        },
                                        inactiveTrackColor:
                                            const Color(0xffF0F2F5),
                                        inactiveThumbColor:
                                            const Color(0xff121212),
                                        trackOutlineColor: WidgetStateProperty
                                            .resolveWith<Color?>(
                                                (Set<WidgetState> states) {
                                          return const Color(0xffE0DCFF);
                                        }),
                                        activeTrackColor:
                                            const Color(0xff121212),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 16,
                                  width: 60,
                                  alignment: Alignment.centerRight,
                                  margin: const EdgeInsets.only(top: 14),
                                  child: const Text(
                                    // userContact.assistantContact
                                    //         ?.assistantName ??
                                    '7:00pm',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff8B8E8C),
                                        fontFamily: MyStrings.outfit),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            );
    });
  }

  Widget logo(String image) {
    return Stack(
      children: [
        Container(
          height: 24,
          width: 24,
          padding: const EdgeInsets.all(5.52),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xff393939),
          ),
          child: Image.asset(
            image,
            width: 13.6,
            height: 13.6,
          ),
        ),
        // Positioned(
        //   top: 0,
        //   right: 3,
        //   child: Container(
        //     height: 4.8,
        //     width: 4.8,
        //     decoration: const BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  void showContactAssistantModal(
      BuildContext context, int? contactId, VoidCallback onSave) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: ContactAssitentComponent(
            contactid: contactId,
            onSave: onSave,
          ),
        );
      },
    );
  }
}


                  // Container(
                  //   height: 103,
                  //   width: MediaQuery.of(context).size.width,
                  //   padding: const EdgeInsets.only(top: 56, bottom: 17),
                  //   decoration: const BoxDecoration(
                  //     color: Colors.black,
                  //     borderRadius: BorderRadius.only(
                  //       bottomLeft: Radius.circular(18),
                  //       bottomRight: Radius.circular(18),
                  //     ),
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 20),
                  //         child: Icon(
                  //           Icons.menu,
                  //           size: 30,
                  //           color: whiteColor,
                  //         ),
                  //       ),
                  //       const SizedBox(width: 20),
                  //       const Text(
                  //         MyStrings.inbox,
                  //         style: TextStyle(
                  //             fontSize: 24,
                  //             fontWeight: FontWeight.w600,
                  //             color: Colors.white,
                  //             fontFamily: MyStrings.outfit),
                  //       ),
                  //       const Spacer(),
                  //       Container(
                  //         height: 24,
                  //         width: 24,
                  //         margin: const EdgeInsets.only(right: 20),
                  //         padding:
                  //             const EdgeInsets.only(top: 2.24, bottom: 2.25),
                  //         child: Icon(Icons.cached_outlined, color: whiteColor),
                  //       ),
                  //     ],
                  //   ),
                  // ),
