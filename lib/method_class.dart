import 'package:flutter/services.dart';

class SmsService {
  static const platform = EventChannel('sms_channel');

  void startListening(Function(String, String) onSmsReceived) {
    platform.receiveBroadcastStream().listen((dynamic data) {
      var sender = data['sender'];
      var message = data['message'];
      onSmsReceived(sender, message);
    });
  }
}
