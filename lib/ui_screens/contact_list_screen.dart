import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sydkic/ui_screens/sms_sender_page.dart';
import '../utils/constant.dart';
import '../utils/string.dart';

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/contact_assistent_model.dart';
import '../model/contactlist_model.dart';
import '../utils/api_constant.dart';
import 'contact_assitent.dart';

class ContactProvider with ChangeNotifier {
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
      ContactProvider contactProvider,
      String assistantId,
      String selectedAssistantName,
      String selectedAssistantID) {
    List<UserContacts> userContacts = contactProvider.userContacts;
    return userContacts.where((contact) {
      return contact.assistantContact?.assistantName == selectedAssistantName &&
          contact.assistantContact?.status == "Active";
    }).toList();
  }
}

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContactProvider>(context, listen: false)
          .fetchContactDetails();
    });
  }

  void refreshContacts() {
    Provider.of<ContactProvider>(context, listen: false).fetchContactDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor.withOpacity(0.3),
      body: Consumer<ContactProvider>(
        builder: (context, contactProvider, child) {
          return contactProvider.isLoading
              ? Center(
            child: CircularProgressIndicator(
              backgroundColor: primaryColor,
              color: Colors.grey,
            ),
          )
              : Stack(
            children: [
              Column(
                children: [
                  // Container(
                  //   height: 30,
                  //   alignment: Alignment.center,
                  //   margin: const EdgeInsets.only(
                  //       left: 20, right: 19.99, top: 40),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.end,
                  //     children: [
                  //       Container(
                  //         padding:
                  //         const EdgeInsets.only(top: 2, bottom: 6),
                  //         child: Icon(
                  //           Icons.menu,
                  //           size: 30,
                  //           color: primaryColor,
                  //         ),
                  //       ),
                  //       const SizedBox(width: 20),
                  //       Text(
                  //         "Contact",
                  //         style: TextStyle(
                  //             color: primaryColor,
                  //             fontSize: 22,
                  //             fontWeight: FontWeight.w500,
                  //             fontFamily: MyStrings.outfit),
                  //       ),
                  //       const Spacer(),
                  //       Container(
                  //         height: 24,
                  //         width: 24,
                  //         margin: const EdgeInsets.only(right: 20),
                  //         padding: const EdgeInsets.only(
                  //             top: 3.38,
                  //             left: 3.4,
                  //             right: 3.4,
                  //             bottom: 3.42),
                  //         child: Icon(Icons.search, color: blackColor),
                  //       ),
                  //       Container(
                  //         height: 24,
                  //         width: 24,
                  //         padding: const EdgeInsets.only(
                  //             top: 2.24, bottom: 2.25),
                  //         child: Icon(Icons.cached_outlined,
                  //             color: primaryColor),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Card(
                  //     color: Colors.white,
                  //     child: Container(
                  //       height: 50,
                  //       width: MediaQuery.of(context).size.width,
                  //       decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //       child: TextFormField(
                  //         onChanged: (value) {
                  //           contactProvider.setSearchQuery(value);
                  //         },
                  //         cursorColor: primaryColor,
                  //         decoration: const InputDecoration(
                  //           prefixIcon: Icon(
                  //             Icons.search,
                  //             color: Color(0xffBBB2B2),
                  //             size: 25,
                  //           ),
                  //           hintText: 'Search Contacts...',
                  //           hintStyle: TextStyle(
                  //               color: Color(0xffBBB2B2),
                  //               fontFamily: MyStrings.outfit),
                  //           enabledBorder: UnderlineInputBorder(
                  //               borderSide: BorderSide.none),
                  //           focusedBorder: UnderlineInputBorder(
                  //               borderSide: BorderSide.none),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: contactProvider.userContacts.length,
                      itemBuilder: (context, index) {
                        UserContacts userContact =
                        contactProvider.userContacts[index];
                        return GestureDetector(
                          onTap: () {
                            // print('id:${userContact.id}');
                            showContactAssistantModal(
                                context, userContact.id);
                            contactProvider.selected(index);
                          },
                          child: Container(
                            height:70,
                            // margin: const EdgeInsets.only(top:10,left:10,right:10),
                            // padding:const EdgeInsets.all(10),
                            // decoration:BoxDecoration(color:whiteColor,borderRadius: BorderRadius.circular(25)),
                            decoration: BoxDecoration(color: whiteColor),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: primaryColor,
                                  child: ClipOval(
                                    child: userContact.profileImg != null
                                        ? CachedNetworkImage(
                                      imageUrl:
                                      userContact.profileImg!,
                                      placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                      errorWidget: (context, url,
                                          error) =>
                                      const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                      width: 50.0,
                                      height: 50.0,
                                    )
                                        : Center(
                                      child: Text(
                                        userContact.name != null
                                            ? userContact.name![0]
                                            .toUpperCase()
                                            : '+91',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: whiteColor,
                                          fontFamily:
                                          MyStrings.outfit,
                                          letterSpacing: 3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      userContact.name != null
                                          ? Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            userContact.name!,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: blackColor,
                                                fontWeight:
                                                FontWeight.w400,
                                                fontFamily:
                                                MyStrings
                                                    .outfit),
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '+${userContact.phone ?? 'No Phone'}',
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Color(
                                                        0xff8B8E8C),
                                                    fontWeight:
                                                    FontWeight
                                                        .w400,
                                                    fontFamily:
                                                    MyStrings
                                                        .outfit),
                                              ),
                                              userContact.assistantContact !=
                                                  null &&
                                                  userContact
                                                      .assistantContact
                                                      ?.status ==
                                                      "Active"
                                                  ? Row(
                                                children: [
                                                  Container(
                                                    height:
                                                    12,
                                                    width: 0,
                                                    margin: const EdgeInsets
                                                        .only(
                                                        left:
                                                        8,
                                                        right:
                                                        8),
                                                    decoration:
                                                    BoxDecoration(
                                                      border:
                                                      Border.all(
                                                        color:
                                                        const Color(0xffD2D2D2),
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(
                                                      Icons
                                                          .smart_toy,
                                                      size:
                                                      16,
                                                      color:
                                                      primaryColor),
                                                  const SizedBox(
                                                    width: 9,
                                                  ),
                                                  Text(
                                                    userContact
                                                        .assistantContact
                                                        ?.assistantName ??
                                                        '',
                                                    style: TextStyle(
                                                        color:
                                                        primaryColor,
                                                        fontSize:
                                                        13,
                                                        fontWeight: FontWeight
                                                            .w400,
                                                        fontFamily:
                                                        MyStrings.outfit),
                                                  ),
                                                ],
                                              )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ],
                                      )
                                          : Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            '+${userContact.phone ?? 'No Phone'}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: blackColor,
                                                fontWeight:
                                                FontWeight.w400,
                                                fontFamily:
                                                MyStrings
                                                    .outfit),
                                          ),
                                          userContact.assistantContact !=
                                              null &&
                                              userContact
                                                  .assistantContact
                                                  ?.status ==
                                                  "Active"
                                              ? Row(
                                            children: [
                                              Icon(
                                                  Icons
                                                      .smart_toy,
                                                  size: 16,
                                                  color:
                                                  primaryColor),
                                              const SizedBox(
                                                width: 9,
                                              ),
                                              Text(
                                                userContact
                                                    .assistantContact
                                                    ?.assistantName ??
                                                    '',
                                                style: TextStyle(
                                                    color:
                                                    primaryColor,
                                                    fontSize:
                                                    13,
                                                    fontWeight:
                                                    FontWeight
                                                        .w400,
                                                    fontFamily:
                                                    MyStrings
                                                        .outfit),
                                              ),
                                            ],
                                          )
                                              : Container(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 10,
                bottom: 90,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SmsExample()));
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        color: primaryColor, shape: BoxShape.circle),
                    child: Center(
                      child: Icon(
                        Icons.messenger,
                        color: whiteColor,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void showContactAssistantModal(BuildContext context, int? contactId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            child: ContactAssitentComponent(
              contactid: contactId,
              onSave: refreshContacts,
            ));
      },
    );
  }
}
