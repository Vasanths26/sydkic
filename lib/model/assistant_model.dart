class AssistantModel {
  String? status;
  List<AssistantList>? assistantList;

  AssistantModel({this.status, this.assistantList});

  AssistantModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['assistant_list'] != null) {
      assistantList = <AssistantList>[];
      json['assistant_list'].forEach((v) {
        assistantList!.add(AssistantList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (assistantList != null) {
      data['assistant_list'] =
          assistantList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssistantList {
  String? assistantId;
  int? contactId;
  String? status;
  String? assistantName;
  int? createdBy;
  // Null? deviceId;
  int? contactCount;

  AssistantList(
      {this.assistantId,
      this.contactId,
      this.status,
      this.assistantName,
      this.createdBy,
      // this.deviceId,
      this.contactCount});

  AssistantList.fromJson(Map<String, dynamic> json) {
    assistantId = json['assistant_id'];
    contactId = json['contact_id'];
    status = json['status'];
    assistantName = json['assistant_name'];
    createdBy = json['created_by'];
    // deviceId = json['device_id'];
    contactCount = json['contact_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assistant_id'] = assistantId;
    data['contact_id'] = contactId;
    data['status'] = status;
    data['assistant_name'] = assistantName;
    data['created_by'] = createdBy;
    // data['device_id'] = this.deviceId;
    data['contact_count'] = contactCount;
    return data;
  }
}