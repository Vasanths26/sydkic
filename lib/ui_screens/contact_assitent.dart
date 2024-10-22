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

class ScheduledProvider extends ChangeNotifier{
  List<UserContacts> _userContacts = [];
  List<ContactAssistant> _contactAssistant = [];
  int _selectedIndex = 0;
  bool _isLoading = false;
  String _assistant = '';
  int _currentIndex = -1;
  CreateAssistantModel? _createAssistant;
  CreateAssistant? _createNewAssistant;

  int get selectedIndex => _selectedIndex;
  bool get isLoading => _isLoading;
  List<UserContacts> get userContacts => _userContacts;
  List<ContactAssistant> get contactAssistant => _contactAssistant;
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
      print('id:$id,assistId:$assistantId,status:$status');
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

}

class ContactAssitentComponent extends StatefulWidget {
  const ContactAssitentComponent(
      {Key? key, required this.contactid, required this.onSave})
      : super(key: key);
  final int? contactid;
  final VoidCallback onSave;

  @override
  State<ContactAssitentComponent> createState() =>
      _ContactAssitentComponentState();
}

class _ContactAssitentComponentState extends State<ContactAssitentComponent> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ScheduledProvider()..fetchContactAssistent(widget.contactid),
      child: Scaffold(
        backgroundColor: Color(0xff121212),
        body: Consumer<ScheduledProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(
                  child: CircularProgressIndicator(color: primaryColor));
            } else if (provider.contactAssistant.isEmpty) {
              return Center(
                child: Image.asset(
                  "asset/image/no data.jpg",
                  height: 250,
                ),
              );
            } else {
              return Container(
                height: 532,
                decoration: const BoxDecoration(
                  color: Color(0xff121212),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 36, right: 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmallText(
                        text: MyStrings.selectTheAssistant,
                        fontFamily: MyStrings.outfit,
                        color: whiteColor,
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: provider.contactAssistant.length,
                          itemBuilder: (context, index) {
                            final userContact =
                                provider.contactAssistant[index];

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
                                margin: const EdgeInsets.only(bottom: 15),
                                padding:
                                    const EdgeInsets.fromLTRB(15.5, 12, 15.5, 12),
                                decoration: BoxDecoration(
                                    color: const Color(0xffE8E4FF),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      userContact.assistantName.toString(),
                                      style: TextStyle(
                                          fontFamily: MyStrings.outfit,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: provider.currentIndex == index
                                              ? primaryColor
                                              : const Color(0xff8B8E8C)),
                                    ),
                                    const Spacer(),
                                    isActive == true
                                        ? Container(
                                            height: 16.67,
                                            width: 16.67,
                                            decoration: BoxDecoration(shape:BoxShape.circle,color:primaryColor),
                                            child: Center(
                                              child: Icon(Icons.check,size: 16.67,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            widget.onSave(); // Ensure this is called after pop
                          });
                        },
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(top: 30),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text('Save',
                                style: TextStyle(
                                    color: whiteColor,
                                    fontFamily: MyStrings.outfit,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          provider.inactivateAllAssistants();
                          Navigator.pop(context);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            widget.onSave(); // Ensure this is called after pop
                          });
                        },
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                              color: blackColor,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(width: 1, color: Colors.grey)),
                          child: const Center(
                            child: Text('Turn Off Assistance',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: MyStrings.outfit,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ),
                      ),
                    ],
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
      print('id:${widget.contactid}');
      print('id:${userContact.assistantId}');
      provider
          .fetchCreateAssistant(
          widget.contactid, userContact.assistantId, "Active")
          .then((newAssistant) {
            print('new:$newAssistant');
        if (newAssistant != null) {
          provider.updatedStauts(index, int.parse('${newAssistant.contactId}'),
              '${newAssistant.status}');
        } else {
          // Handle the null case, e.g., show an error message or take other actions
          print('value:${newAssistant?.status}');
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
