import 'dart:async';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sydkic/ui_screens/sign_in_screen.dart';
import 'package:sydkic/ui_screens/sms_screen.dart';
import 'package:sydkic/utils/constant.dart';
import 'package:http/http.dart' as http;
import '../model/sms_model.dart';
import '../utils/api_constant.dart';
import 'contact_list_screen.dart';
import 'package:easy_sms_receiver/easy_sms_receiver.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // static const eventChannel = EventChannel('com.example.sydkic/sms');
  // StreamSubscription? _smsSubscription;
  ReceiveSmsModel? _data;

  // @override
  // void initState() {
  //   super.initState();
  //   requestSmsPermission();
  //   loadMessages();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _smsSubscription =
  //         eventChannel.receiveBroadcastStream().listen((dynamic event) {
  //       print("Received event: $event");

  //       if (!mounted) return;
  //       final Map<String, String> sms = Map<String, String>.from(event);

  //       // Update the provider with the new message
  //       Provider.of<MessageProvider>(context, listen: false).addMessage(sms);

  //       saveMessage(sms['sender'] ?? 'Unknown', sms['message'] ?? 'No message');
  //       fetchData(sms['sender'] ?? 'Unknown', sms['message'] ?? 'No message');
  //     });
  //   });
  // }

  // @override
  // void dispose() {
  //   _smsSubscription
  //       ?.cancel(); // Cancel the subscription when disposing the widget

  //   super.dispose();
  // }

  // Future<void> requestSmsPermission() async {
  //   PermissionStatus status = await Permission.sms.request();
  //   if (status != PermissionStatus.granted) {
  //     // Permission was denied or not granted
  //     print("SMS permission denied.");
  //   }
  // }

  // Future<void> loadMessages() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final storedMessages = prefs.getStringList('messages') ?? [];
  //   final messages = storedMessages.map((m) {
  //     final split = m.split(': ');
  //     return {'sender': split[0], 'message': split[1]};
  //   }).toList();

  //   // Load the messages into the provider
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<MessageProvider>(context, listen: false)
  //         .loadMessages(messages);
  //   });
  // }

  // Future<void> saveMessage(String sender, String message) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final storedMessages = prefs.getStringList('messages') ?? [];
  //   storedMessages.add('$sender: $message');
  //   prefs.setStringList('messages', storedMessages);
  // }
  final EasySmsReceiver _easySmsReceiver = EasySmsReceiver.instance;
  final List<SmsMessage> _messages = [];

  @override
  void initState() {
    super.initState();

    _requestSmsPermission();
    loadMessages();
  }

  @override
  void dispose() {
    // _smsReceiver.stopListening();  // Stop listening when disposing the widget
    super.dispose();
  }

  Future<void> _requestSmsPermission() async {
    var status = await Permission.sms.request();
    if (status == PermissionStatus.granted) {
      _startSmsReceiver();
    }
  }

  void _startSmsReceiver() {
    _easySmsReceiver.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        setState(() {
          _messages.insert(0, message); // Use the provided 'message' directly
          saveMessage('${message.address}', '${message.body}');
          fetchData('${message.address}', '${message.body}');
        });
      },
    );
  }

  Future<void> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final storedMessages = prefs.getStringList('messages') ?? [];
    final messages = storedMessages.map((m) {
      final split = m.split(': ');
      return {'sender': split[0], 'message': split[1]};
    }).toList();

    // Load the messages into the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MessageProvider>(context, listen: false)
          .loadMessages(messages);
    });
  }

  Future<void> saveMessage(String sender, String message) async {
    final prefs = await SharedPreferences.getInstance();
    final storedMessages = prefs.getStringList('messages') ?? [];
    storedMessages.add('$sender: $message');
    print('message:$storedMessages');
    prefs.setStringList('messages', storedMessages);
  }

  final customCacheManager = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
    ),
  );

  Future<void> fetchData(String phoneNumber, String message) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
      };
      final body =
          jsonEncode({'phone_number': phoneNumber, 'text_message': message});
      var response = await http.post(
        Uri.parse(ApiConstants.receiveSms),
        body: body,
        headers: headers,
      );
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        ReceiveSmsModel receiveModel = ReceiveSmsModel.fromJson(jsonData);
        setState(() {
          _data = receiveModel;
        });
        _showMessage('${_data!.status}', context);
      } else {
        if (kDebugMode) {
          print('Failed to fetch contacts: ${response.statusCode}');
        }
      }
    } catch (e) {
      // print(e);
    }
  }

  void _showMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts', style: TextStyle(color: whiteColor)),
        backgroundColor: const Color(0xff45474b),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const ContactListScreen(),
      drawer: Container(
        height: MediaQuery.of(context).size.height,
        width: 180,
        decoration: BoxDecoration(
          color: whiteColor,
        ),
        child: TextButton(
          onPressed: () {
            logout(context);
          },
          child: const Text('log out'),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (route) => false,
    );
  }
}
