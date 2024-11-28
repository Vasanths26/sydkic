import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/contact_assistent_model.dart';
import '../model/contactlist_model.dart';
import '../utils/api_constant.dart';
import '../utils/constant.dart';
import '../utils/small_text.dart';
import '../utils/string.dart';
import 'package:http/http.dart' as http;

class ScheduledProvider extends ChangeNotifier {
  List<UserContacts> _userContacts = [];
  List<ContactAssistant> _contactAssistant = [];
  List<ContactAssistant> _filteredAssistant = [];
  int _selectedIndex = 0;
  bool _isLoading = false;
  String _assistant = '';
  int _currentIndex = -1;
  CreateAssistantModel? _createAssistant;
  CreateAssistant? _createNewAssistant;
  bool _isShowSearchList = false;

  int get selectedIndex => _selectedIndex;
  bool get isLoading => _isLoading;
  bool get isShowSearchList => _isShowSearchList;
  List<UserContacts> get userContacts => _userContacts;
  List<ContactAssistant> get contactAssistant => _contactAssistant;
  List<ContactAssistant> get filteredAssistant => _filteredAssistant;
  String get assistant => _assistant;
  int get currentIndex => _currentIndex;
  CreateAssistantModel? get createAssistant => _createAssistant;
  CreateAssistant? get createNewAssistant => _createNewAssistant;

  bool _isActive = false;
  bool get isActive => _isActive;

  void active(value) {
    _isActive = value;
    notifyListeners();
  }

  void assistantValues(value) {
    _assistant = value;
    notifyListeners();
  }

  void select(index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void inactivateAllAssistants() {
    for (var assistant in contactAssistant) {
      assistant.status = "Inactive"; // Set status to Inactive
    }
    notifyListeners(); // Notify the listeners to rebuild the UI
  }

  void current(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<List<ContactAssistant>> fetchContactAssistent(contactid) async {
    _isLoading = true;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('authorization');

    if (kDebugMode) {
      print("access token $token");
    }
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

  // for status changes from api

  Future<void> fetchData(int? id, String? assistantId, String? status) async {
    // _isLoading = true;
    // notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('authorization');
    try {
      var response = await http.get(
        Uri.parse(
            '${ApiConstants.createAssistentContact}/$id/$assistantId/$status'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (kDebugMode) {
        print('id:$id,assistId:$assistantId,status:$status');
      }
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        _createAssistant = CreateAssistantModel.fromJson(jsonData);
        _assistant = '${_createAssistant!.assistantStatus}';
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
      // _isLoading = false;
      // notifyListeners();
    }
  }

  //to create new assistant for contacts

  Future<CreateAssistant?> fetchCreateAssistant(
      int? id, String? assistantId, String? status) async {
    // _isLoading = true;
    // notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('authorization');
    try {
      var response = await http.get(
        Uri.parse(
            '${ApiConstants.createAssistentContact}/$id/$assistantId/$status'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        CreateNewAssistant createNew = CreateNewAssistant.fromJson(jsonData);
        _createNewAssistant = createNew.createAssistant;
      } else {
        if (kDebugMode) {
          print('Failed to fetch new assistant: ${response.statusCode}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching assistant: $error');
      }
    } finally {
      // _isLoading = false;
      // notifyListeners();
    }
    return _createNewAssistant;
  }

  void updatedStauts(int index, int contactId, String status) {
    if (_contactAssistant[index].assistantId ==
        _createNewAssistant!.assistantId) {
      _contactAssistant[index].contactId = contactId;
      _contactAssistant[index].status = status;
    }
    notifyListeners();
  }

  void statusUpdate(String data) {
    data;
    notifyListeners();
  }

  void filterNames(String query) {
    if (query.isEmpty) {
      _isShowSearchList = false;
    } else {
      _isShowSearchList = true;
      _filteredAssistant = contactAssistant
          .where((assistant) =>
              assistant.assistantName != null &&
              assistant.assistantName!
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

class ContactAssitentComponent extends StatefulWidget {
  const ContactAssitentComponent(
      {super.key, required this.contactid, required this.onSave});
  final int? contactid;
  final VoidCallback onSave;

  @override
  State<ContactAssitentComponent> createState() =>
      _ContactAssitentComponentState();
}

class _ContactAssitentComponentState extends State<ContactAssitentComponent> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ScheduledProvider()..fetchContactAssistent(widget.contactid),
      child: Scaffold(
        backgroundColor: const Color(0xffFFFFFF),
        body: Consumer<ScheduledProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(
                child: CircularProgressIndicator(color: blackColor),
              );
            } else if (provider.contactAssistant.isEmpty) {
              return Center(
                child: Image.asset(
                  "asset/image/no data.jpg",
                  height: 250,
                ),
              );
            } else {
              return SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  height: 532,
                  decoration: const BoxDecoration(
                    color: Color(0xffFFFFFF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 25, right: 25, bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            height: 5,
                            width: 30,
                            margin: const EdgeInsets.only(
                              bottom: 15,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xffD0CBEF),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SmallText(
                              text: MyStrings.selectTheAssistant,
                              fontFamily: MyStrings.outfit,
                              color: primaryColor,
                              size: 16,
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.close,
                                  size: 20, color: primaryColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Container(
                          height: 45,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.fromLTRB(15, 12, 15, 12),
                          decoration: BoxDecoration(
                              color: const Color(0xffF0F2F5),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2.25),
                                child: Icon(Icons.search,
                                    size: 18, color: secondaryColor),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 1),
                                  child: TextFormField(
                                    controller: searchController,
                                    onChanged: (value) {
                                      provider.filterNames(value);
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search assistance...',
                                      hintStyle: TextStyle(
                                        fontFamily: MyStrings.outfit,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                        color: secondaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: provider.isShowSearchList == true
                                ? provider.filteredAssistant.length
                                : provider.contactAssistant.length,
                            itemBuilder: (context, index) {
                              final userContact = provider.isShowSearchList
                                  ? provider.filteredAssistant[index]
                                  : provider.contactAssistant[index];
                              bool hasAssistantContact =
                                  userContact.assistantName != null &&
                                      userContact.createdBy != null;

                              if (!hasAssistantContact ||
                                  userContact.assistantName == null ||
                                  userContact.createdBy == null) {
                                return const SizedBox();
                              }
                              bool isActive =
                                  widget.contactid == userContact.contactId &&
                                      userContact.status == "Active";
                              return GestureDetector(
                                onTap: () {
                                  provider.select(index);
                                  _onItemTap(
                                      index, userContact, provider, !isActive);
                                },
                                child: Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  decoration: BoxDecoration(
                                      color: const Color(0xffF0F2F5),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        userContact.assistantName.toString(),
                                        style: TextStyle(
                                            fontFamily: MyStrings.outfit,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color:
                                                provider.currentIndex == index
                                                    ? primaryColor
                                                    : secondaryColor),
                                      ),
                                      const Spacer(),
                                      isActive == true
                                          ? Container(
                                              height: 16.67,
                                              width: 16.67,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: primaryColor),
                                              child: Center(
                                                child: Icon(Icons.check,
                                                    size: 16.67,
                                                    color: whiteColor),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 28, left: 15, right: 15, bottom: 15),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  provider.inactivateAllAssistants();
                                  Navigator.pop(context);
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    widget
                                        .onSave(); // Ensure this is called after pop
                                  });
                                },
                                child: Container(
                                  height: 45,
                                  width:
                                      MediaQuery.of(context).size.width * 0.374,
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        width: 1, color: primaryColor),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Back',
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontFamily: MyStrings.outfit,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 23),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    widget
                                        .onSave(); // Ensure this is called after pop
                                  });
                                },
                                child: Container(
                                  height: 45,
                                  width:
                                      MediaQuery.of(context).size.width * 0.374,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                    child: Text('Confirm',
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontFamily: MyStrings.outfit,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _onItemTap(int index, ContactAssistant userContact,
      ScheduledProvider provider, bool isActive) {
    if (widget.contactid == userContact.contactId) {
      // Update tapped item status and show snackbar
      // print('assisId: ${provider.contactAssistant[index].assistantId}');
      provider.assistantValues(provider.contactAssistant[index].assistantId);
      provider
          .statusUpdate(userContact.status = isActive ? "Active" : "Inactive");
      _showSnackBar(isActive);
      provider.fetchData(widget.contactid, userContact.assistantId,
          isActive ? "Active" : "Inactive");
    } else {
      // Update tapped item status (already inactive in previous code)
      // and show snackbar
      // print('assistantId: ${provider.contactAssistant[index].assistantId}');
      provider.assistantValues(provider.contactAssistant[index].assistantId);
      provider.statusUpdate(userContact.status = "Inactive");
      // Create a new assistant (assuming widget.contactid is valid)
      if (kDebugMode) {
        print('id:${widget.contactid}');
      }
      if (kDebugMode) {
        print('id:${userContact.assistantId}');
      }
      provider
          .fetchCreateAssistant(
              widget.contactid, userContact.assistantId, "Active")
          .then((newAssistant) {
        if (kDebugMode) {
          print('new:$newAssistant');
        }
        if (newAssistant != null) {
          provider.updatedStauts(index, int.parse('${newAssistant.contactId}'),
              '${newAssistant.status}');
        } else {
          // Handle the null case, e.g., show an error message or take other actions
          if (kDebugMode) {
            print('value:${newAssistant?.status}');
          }
        }
      });

      _showSnackBar(isActive);
    }
  }

  void _showSnackBar(bool isActive) {
    String snackBarText =
        isActive ? "Assistant Activated" : "Assistant Deactivated";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 800),
        content: Text(
          snackBarText,
          style: const TextStyle(
            fontFamily: MyStrings.outfit,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
