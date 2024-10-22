class ScheduledModel {
  String? status;
  List<ScheduleList>? scheduleList;

  ScheduledModel({this.status, this.scheduleList});

  ScheduledModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['schedule_list'] != null) {
      scheduleList = <ScheduleList>[];
      json['schedule_list'].forEach((v) {
        scheduleList!.add(ScheduleList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (scheduleList != null) {
      data['schedule_list'] =
          scheduleList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScheduleList {
  int? id;
  int? userId;
  int? deviceId;
  Null templateId;
  String? title;
  String? body;
  String? scheduleAt;
  String? zone;
  Null date;
  Null time;
  String? status;
  String? createdAt;
  String? updatedAt;
  Null template;

  ScheduleList(
      {this.id,
      this.userId,
      this.deviceId,
      this.templateId,
      this.title,
      this.body,
      this.scheduleAt,
      this.zone,
      this.date,
      this.time,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.template});

  ScheduleList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    deviceId = json['device_id'];
    templateId = json['template_id'];
    title = json['title'];
    body = json['body'];
    scheduleAt = json['schedule_at'];
    zone = json['zone'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    template = json['template'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['device_id'] = deviceId;
    data['template_id'] = templateId;
    data['title'] = title;
    data['body'] = body;
    data['schedule_at'] = scheduleAt;
    data['zone'] = zone;
    data['date'] = date;
    data['time'] = time;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['template'] = template;
    return data;
  }
}
