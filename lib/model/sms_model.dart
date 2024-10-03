// To parse this JSON data, do
//
//     final smsSendModel = smsSendModelFromJson(jsonString);

import 'dart:convert';

SmsSendModel smsSendModelFromJson(String str) => SmsSendModel.fromJson(json.decode(str));

String smsSendModelToJson(SmsSendModel data) => json.encode(data.toJson());

class SmsSendModel {
    String status;
    String phoneNumber;
    String textMessage;

    SmsSendModel({
        required this.status,
        required this.phoneNumber,
        required this.textMessage,
    });

    factory SmsSendModel.fromJson(Map<String, dynamic> json) => SmsSendModel(
        status: json["status"],
        phoneNumber: json["phone_number"],
        textMessage: json["text_message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "phone_number": phoneNumber,
        "text_message": textMessage,
    };
}

class ReceiveSmsModel {
  String? status;

  ReceiveSmsModel({this.status});

  ReceiveSmsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    return data;
  }
}
