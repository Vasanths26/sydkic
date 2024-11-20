import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
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
  final TextEditingController _controller = TextEditingController();
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
                backgroundColor: blackColor,
                body: Center(
                  child: CircularProgressIndicator(color: whiteColor),
                ),
              )
            : Scaffold(
                backgroundColor: blackColor,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(144),
                  child: Container(
                    height: 144,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('asset/image/image.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    padding:
                        const EdgeInsets.only(left: 20, top: 68, bottom: 20),
                    child: Container(
                      height: 46,
                      margin: const EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 7,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: const Color(0xff000000).withOpacity(0.5),
                        border: Border.all(color: primaryColor, width: 1),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.3), // Light black shadow
                              offset: const Offset(5,
                                  5), // Horizontal and vertical shadow position
                              blurRadius: 10,
                              spreadRadius: 0 // Spread radius
                              ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 14, bottom: 14),
                            child: Icon(Icons.search,
                                color: primaryColor, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 13.5, bottom: 13.5),
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
                          Container(
                            height: 32,
                            width: 32,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  whiteColor.withOpacity(1),
                                  primaryColor.withOpacity(1),
                                ],
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'asset/image/round_profile.webp',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                body: ListView.builder(
                  shrinkWrap: true,
                  itemCount: webChatProvider.userContacts.length,
                  itemBuilder: (context, index) {
                    UserContacts userContact =
                        webChatProvider.userContacts[index];
                    return Stack(
                      children: [
                        Container(
                          height: 87,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(
                              left: 15, top: 20, bottom: 20, right: 15),
                          decoration: BoxDecoration(
                            border: GradientBoxBorder(
                              width: 1,
                              gradient: RadialGradient(colors: [
                                primaryColor.withOpacity(1),
                                onyxColor.withOpacity(0),
                              ], center: Alignment.bottomCenter, radius: 2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
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
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              userContact.profileImg != null &&
                                                      userContact.profileImg!
                                                          .isNotEmpty
                                                  ? whiteColor
                                                  : whiteColor,
                                        ),
                                        child: userContact.profileImg != null &&
                                                userContact
                                                    .profileImg!.isNotEmpty
                                            ? ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      userContact.profileImg!,
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Center(
                                                    child: Text(
                                                      userContact.name !=
                                                                  null &&
                                                              userContact.name!
                                                                  .isNotEmpty
                                                          ? userContact.name!
                                                              .substring(0, 1)
                                                              .toUpperCase() // First letter of the name
                                                          : "+${userContact.phone!.substring(0, 2)}", // + and first two digits of phone number
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              blackColor, // Text color
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
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          blackColor, // Text color
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          MyStrings.outfit),
                                                ),
                                              ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 21,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              userContact.name ??
                                                  '+${userContact.phone ?? 'No Phone'}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: homeTextColor,
                                                  fontFamily: MyStrings.outfit),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Container(
                                                height: 18,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '5m ago',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: secondaryColor,
                                                      fontFamily:
                                                          MyStrings.outfit),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      index != 1 && index != 4
                                          ? logo(
                                              'asset/image/whatsapp-logo.png')
                                          : Container(),
                                      index == 1
                                          ? Row(
                                              children: [
                                                logo(
                                                    'asset/image/instagram-device 1.png'),
                                                const SizedBox(width: 5),
                                              ],
                                            )
                                          : Container(),
                                      index == 1
                                          ? Row(
                                              children: [
                                                logo(
                                                    'asset/image/envelope-device 1.png'),
                                                const SizedBox(width: 5),
                                              ],
                                            )
                                          : Container(),
                                      index == 1 || index == 4
                                          ? Row(
                                              children: [
                                                logo('asset/image/talk 1.png'),
                                                const SizedBox(width: 5),
                                              ],
                                            )
                                          : Container(),
                                      index == 1 || index == 4
                                          ? logo('asset/image/web-chat 1.png')
                                          : Container(),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 15,
                          left: 46,
                          child: index >= 0 && index <= 5
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: blackColor,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(0, 4),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                        color: blackColor.withOpacity(0.2),
                                      ),
                                    ],
                                    color: whiteColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '55',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        )
                      ],
                    );
                  },
                ),
              );
      },
    );
  }

  Widget logo(String image) {
    return Stack(
      children: [
        Container(
          height: 24,
          width: 24,
          padding: const EdgeInsets.all(5.52),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: raisinBlack,
          ),
          child: Image.asset(
            image,
            width: 13.6,
            height: 13.6,
          ),
        ),
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

// index >= 1 && index <= 10
//                                               ? Container(
//                                                   height: 20,
//                                                   width: 20,
//                                                   decoration: BoxDecoration(
//                                                       color: whiteColor,
//                                                       shape: BoxShape.circle),
//                                                   child: Center(
//                                                     child: Text(
//                                                       '55',
//                                                       style: TextStyle(
//                                                         color: blackColor,
//                                                         fontSize: 8,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               : Container(),
