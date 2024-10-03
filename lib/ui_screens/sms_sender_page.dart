import 'dart:convert';
// import 'package:easy_sms_receiver/easy_sms_receiver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:background_sms/background_sms.dart';
import 'package:http/http.dart' as http;
import '../utils/api_constant.dart';
import '../model/sms_model.dart';
import '../utils/constant.dart';

import 'sms_screen.dart';

class SmsMessage {
  final String address;
  final String body;

  SmsMessage({required this.address, required this.body});
}

class SmsExample extends StatefulWidget {
  const SmsExample({super.key});

  @override
  State<SmsExample> createState() => _SmsExampleState();
}

class _SmsExampleState extends State<SmsExample> {
  // final EasySmsReceiver _easySmsReceiver = EasySmsReceiver.instance;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final List<SmsMessage> _sentMessages = [];
  final List<SmsMessage> _messages = [];
  ReceiveSmsModel? _data;
  bool _isData = false;

  @override
  void initState() {
    super.initState();
    _requestSmsPermission();
  }

  Future<void> _requestSmsPermission() async {
    var status = await Permission.sms.request();
    if (status == PermissionStatus.granted) {
      // _startSmsReceiver();
    }
  }

  // void _startSmsReceiver() {
  //   _easySmsReceiver.listenIncomingSms(
  //     onNewMessage: (message) {
  //       final smsMessage = SmsMessage(
  //         address: '${message.address}',
  //         body: '${message.body}',
  //       );
  //       setState(() {
  //         _messages.insert(0, smsMessage);
  //       });
  //     },
  //   );
  // }

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
        if (_data!.status == 'success') {
          setState(() {
            final smsMessage = SmsMessage(
              address: phoneNumber,
              body: message,
            );
            _sentMessages.insert(0, smsMessage);
          });
          // print('length:${_sentMessages.length}');
          _showMessage('Sms send successfully', context);
        } else {
          _showMessage('Failed to send SMS', context);
        }
      } else {
        if (kDebugMode) {
          print('Failed to fetch contacts: ${response.statusCode}');
        }
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> sendSms(
      String phoneNumber, String message, BuildContext context) async {
    try {
      if (phoneNumber.isNotEmpty && message.isNotEmpty) {
        SmsStatus result = await BackgroundSms.sendMessage(
          phoneNumber: phoneNumber,
          message: message,
        );
        if (result == SmsStatus.sent) {
          // await _fetchSmsMessages(phoneNumber, message);
          fetchData(phoneNumber, message);
          _sentMessages.insert(0, SmsMessage(address: phoneNumber, body: message));
        } else {
          fetchData(phoneNumber, message);
        }
      }
    } catch (error) {
      // print('error : $error');
    }
  }

  void toggleDataView() {
    setState(() {
      _isData = !_isData;
    });
  }

  void _showMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Example'),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SmsScreen()));
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.chat_outlined,
                  size: 30,
                ),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendSms(
              _phoneNumberController.text, _messageController.text, context);
          _phoneNumberController.clear();
          _messageController.clear();
        },
        backgroundColor: primaryColor,
        shape: const CircleBorder(),
        child: Icon(
          Icons.send_outlined,
          color: whiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: 80,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: toggleDataView,
                    child: Container(
                      margin: const EdgeInsets.only(
                          bottom: 20, top: 20, left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: _isData != true ? primaryColor : whiteColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: primaryColor,
                              width: _isData != true ? 0 : 1)),
                      height: 60,
                      width: 80,
                      child: Center(
                        child: Text('send',
                            style: TextStyle(
                                color: _isData != true
                                    ? whiteColor
                                    : primaryColor)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: toggleDataView,
                    child: Container(
                      margin: const EdgeInsets.only(
                          bottom: 20, top: 20, left: 10, right: 10),
                      height: 60,
                      width: 80,
                      decoration: BoxDecoration(
                          color: _isData == true ? primaryColor : whiteColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: primaryColor,
                              width: _isData == true ? 0 : 1)),
                      child: Center(
                        child: Text(
                          'Inbox',
                          style: TextStyle(
                              color:
                                  _isData == true ? whiteColor : primaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _sentMessages.isEmpty || _messages.isEmpty
                  ? Center(
                      child: Text(
                        'No Messages Found',
                        style: TextStyle(color: primaryColor),
                      ),
                    )
                  : ListView.separated(
                      itemCount:  _sentMessages.length,
                      itemBuilder: (context, index) {
                        final List<dynamic> data = _sentMessages;

                        if (index < data.length) {
                          // Check index within bounds
                          final message = data[index];
                          return smsWidget(
                              context, message.address, message.body);
                        } else {
                          // Handle out-of-bounds case (optional)
                          return Container(); // Or display an error message
                        }
                      },
                      separatorBuilder: (context, index) => const Divider(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget smsWidget(
      BuildContext context, String phoneNumber, String textMessage) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(),
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(phoneNumber),
                const SizedBox(height: 10),
                SizedBox(height: 60, width: 250, child: Text(textMessage)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
