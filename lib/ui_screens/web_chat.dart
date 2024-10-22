import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
      WebChatProvider WebChatProvider,
      String assistantId,
      String selectedAssistantName,
      String selectedAssistantID) {
    List<UserContacts> userContacts = WebChatProvider.userContacts;
    return userContacts.where((contact) {
      return contact.assistantContact?.assistantName == selectedAssistantName &&
          contact.assistantContact?.status == "Active";
    }).toList();
  }
}

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<bool> switchStates = List.generate(10, (index) => false);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WebChatProvider>(context, listen: false)
          .fetchContactDetails();
    });
  }

  void refreshContacts() {
    Provider.of<WebChatProvider>(context, listen: false).fetchContactDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WebChatProvider>(
        builder: (context, webChatProvider, child) {
      return webChatProvider.isLoading
          ? Scaffold(
              backgroundColor: Color(0xff121212),
              body: Center(
                child: CircularProgressIndicator(
                  backgroundColor: whiteColor,
                  color: Colors.grey,
                ),
              ),
            )
          : Scaffold(
              backgroundColor: Color(0xff121212),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 58),
                    child: const Text(MyStrings.inbox,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: MyStrings.outfit)),
                  ),
                  Container(
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        left: 20, top: 15, right: 20, bottom: 5),
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      border: Border.all(width: 1, color: whiteColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      onChanged: (value) {
                        // WebChatProvider.setSearchQuery(value);
                      },
                      style: TextStyle(color:whiteColor,fontFamily:MyStrings.outfit),
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 24,
                        ),
                        hintText: 'Search Contacts...',
                        hintStyle: TextStyle(
                            color: Colors.white, fontFamily: MyStrings.outfit),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12), // Adjust padding
                        enabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: webChatProvider.userContacts.length,
                        itemBuilder: (context, index) {
                          UserContacts userContact =
                              webChatProvider.userContacts[index];
                          return Container(
                            height: 78,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(
                                left: 20, top: 15, bottom: 15, right: 20),
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
                                        : const Color(0xff5548B1),
                                  ),
                                  child: userContact.profileImg != null &&
                                          userContact.profileImg!.isNotEmpty
                                      ? ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: userContact.profileImg!,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            userContact.name != null &&
                                                    userContact.name!.isNotEmpty
                                                ? userContact.name!
                                                    .substring(0, 1)
                                                    .toUpperCase() // First letter of the name
                                                : "+${userContact.phone!.substring(0, 2)}", // + and first two digits of phone number
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color:
                                                    Colors.white, // Text color
                                                fontWeight: FontWeight.w400,
                                                fontFamily: MyStrings.outfit),
                                          ),
                                        ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 18,
                                      width: 151,
                                      child: Text(
                                          userContact.name ??
                                              '+${userContact.phone ?? 'No Phone'}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                              fontFamily: MyStrings.outfit)),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        logo('asset/image/whatsapp-logo.png'),
                                        const SizedBox(width: 5),
                                        logo('asset/image/instagram.png'),
                                        const SizedBox(width: 5),
                                        logo('asset/image/mail-logo.png'),
                                      ],
                                    ),
                                  ],
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
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Transform.scale(
                                          scale: 0.75,
                                          child: Switch(
                                            value: userContact
                                                            .assistantContact !=
                                                        null &&
                                                    userContact.assistantContact
                                                            ?.status ==
                                                        "Active"
                                                ? true
                                                : false,
                                            onChanged: (value) {
                                              showContactAssistantModal(
                                                  context,
                                                  userContact.id,
                                                  refreshContacts);
                                            },
                                            inactiveTrackColor:
                                                const Color(0xffFFFFFF),
                                            inactiveThumbColor:
                                                const Color(0xff121212),
                                            trackOutlineColor:
                                                WidgetStateProperty.resolveWith<
                                                        Color?>(
                                                    (Set<WidgetState> states) {
                                              return const Color(0xffE0DCFF);
                                            }),
                                            activeTrackColor:
                                                const Color(0xff121212),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 16,
                                        width: 60,
                                        alignment: Alignment.centerRight,
                                        margin: const EdgeInsets.only(top: 14),
                                        child: Text(
                                          userContact.assistantContact
                                                  ?.assistantName ??
                                              '',
                                          style: const TextStyle(
                                              fontSize: 13,
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
                  ),
                ],
              ),
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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: Image.asset(
            image,
            width: 13.6,
            height: 13.6,
          ),
        ),
        Positioned(
          top: 0,
          right: 3,
          child: Container(
            height: 4.8,
            width: 4.8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
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
            ));
      },
    );
  }
}
