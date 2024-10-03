class ContactAssistentModel {
  String? status;
  List<ContactAssistant>? contactAssistant;

  ContactAssistentModel({this.status, this.contactAssistant});

  ContactAssistentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['contact_assistant'] != null) {
      contactAssistant = <ContactAssistant>[];
      json['contact_assistant'].forEach((v) {
        contactAssistant!.add(ContactAssistant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (contactAssistant != null) {
      data['contact_assistant'] =
          contactAssistant!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ContactAssistant {
  String? assistantId;
  int? contactId;
  String? status;
  String? assistantName;
  int? createdBy;
  int? deviceId;

  ContactAssistant(
      {this.assistantId,
      this.contactId,
      this.status,
      this.assistantName,
      this.createdBy,
      this.deviceId});

  ContactAssistant.fromJson(Map<String, dynamic> json) {
    assistantId = json['assistant_id'];
    contactId = json['contact_id'];
    status = json['status'];
    assistantName = json['assistant_name'];
    createdBy = json['created_by'];
    deviceId = json['device_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assistant_id'] = assistantId;
    data['contact_id'] = contactId;
    data['status'] = status;
    data['assistant_name'] = assistantName;
    data['created_by'] = createdBy;
    data['device_id'] = deviceId;
    return data;
  }
}

class CreateAssistantModel {
  String? status;
  String? assistantStatus;

  CreateAssistantModel({this.status, this.assistantStatus});

  CreateAssistantModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    assistantStatus = json['assistant_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['assistant_status'] = assistantStatus;
    return data;
  }
}

class CreateNewAssistant {
  String? status;
  CreateAssistant? createAssistant;

  CreateNewAssistant({this.status, this.createAssistant});

  CreateNewAssistant.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    createAssistant = json['cretaed_assistant'] != null
        ? CreateAssistant.fromJson(json['cretaed_assistant'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (createAssistant != null) {
      data['cretaed_assistant'] = createAssistant!.toJson();
    }
    return data;
  }
}

class CreateAssistant {
  String? assistantId;
  int? contactId;
  String? threadId;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  String? startAt;
  String? startAtTimezone;
  String? fileIds;
  String? assistantName;
  String? assistantDesc;
  String? assistantAgentName;
  int? deviceId;

  CreateAssistant(
      {this.assistantId,
      this.contactId,
      this.threadId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.startAt,
      this.startAtTimezone,
      this.fileIds,
      this.assistantName,
      this.assistantDesc,
      this.assistantAgentName,
      this.deviceId});

  CreateAssistant.fromJson(Map<String, dynamic> json) {
    assistantId = json['assistant_id'];
    contactId = json['contact_id'];
    threadId = json['thread_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    startAt = json['start_at'];
    startAtTimezone = json['start_at_timezone'];
    fileIds = json['file_ids'];
    assistantName = json['assistant_name'];
    assistantDesc = json['assistant_desc'];
    assistantAgentName = json['assistant_agent_name'];
    deviceId = json['device_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assistant_id'] = assistantId;
    data['contact_id'] = contactId;
    data['thread_id'] = threadId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['start_at'] = startAt;
    data['start_at_timezone'] = startAtTimezone;
    data['file_ids'] = fileIds;
    data['assistant_name'] = assistantName;
    data['assistant_desc'] = assistantDesc;
    data['assistant_agent_name'] = assistantAgentName;
    data['device_id'] = deviceId;
    return data;
  }
}

class AssistantContactModel {
  String? status;
  List<AssistantContacts>? assistantContacts;

  AssistantContactModel({this.status, this.assistantContacts});

  AssistantContactModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['assistant_contacts'] != null) {
      assistantContacts = <AssistantContacts>[];
      json['assistant_contacts'].forEach((v) {
        assistantContacts!.add(AssistantContacts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (assistantContacts != null) {
      data['assistant_contacts'] =
          assistantContacts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssistantContacts {
  String? name;
  String? phone;
  String? profileImg;
  String? assistantStatus;
  String? assistantId;
  int? contactId;

  AssistantContacts(
      {this.name,
      this.phone,
      this.profileImg,
      this.assistantStatus,
      this.assistantId,
      this.contactId});

  AssistantContacts.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    profileImg = json['profile_img'];
    assistantStatus = json['assistant_status'];
    assistantId = json['assistant_id'];
    contactId = json['contact_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['profile_img'] = profileImg;
    data['assistant_status'] = assistantStatus;
    data['assistant_id'] = assistantId;
    data['contact_id'] = contactId;
    return data;
  }
}