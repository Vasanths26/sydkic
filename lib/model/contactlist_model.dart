class ContactModel {
  String? status;
  List<UserContacts>? userContacts;
  List<AssistantContact>? assistantContact;

  ContactModel({this.status, this.userContacts, this.assistantContact});

  ContactModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['user_contacts'] != null) {
      userContacts = <UserContacts>[];
      json['user_contacts'].forEach((v) {
        userContacts!.add(UserContacts.fromJson(v));
      });
    }
    if (json['assistant_contact'] != null) {
      assistantContact = <AssistantContact>[];
      json['assistant_contact'].forEach((v) {
        assistantContact!.add(AssistantContact.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (userContacts != null) {
      data['user_contacts'] = userContacts!.map((v) => v.toJson()).toList();
    }
    if (assistantContact != null) {
      data['assistant_contact'] = assistantContact!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserContacts {
  int? id;
  int? userId;
  String? name;
  String? phone;
  String? createdAt;
  String? updatedAt;
  String? companyName;
  String? jobTitle;
  String? email;
  String? dateOfBirth;
  String? anniversaryDate;
  String? categoryId;
  String? countryCode;
  String? deviceUuid;
  String? devicePhone;
  String? profileImg;
  int? profileStatus;
  int? liteReceivedMsgCount;
  int? liteSentMsgCount;
  AssistantContact? assistantContact;

  UserContacts(
      {this.id,
        this.userId,
        this.name,
        this.phone,
        this.createdAt,
        this.updatedAt,
        this.companyName,
        this.jobTitle,
        this.email,
        this.dateOfBirth,
        this.anniversaryDate,
        this.categoryId,
        this.countryCode,
        this.deviceUuid,
        this.devicePhone,
        this.profileImg,
        this.profileStatus,
        this.liteReceivedMsgCount,
        this.liteSentMsgCount,
        this.assistantContact});

  UserContacts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    phone = json['phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    companyName = json['company_name'];
    jobTitle = json['job_title'];
    email = json['email'];
    dateOfBirth = json['date_of_birth'];
    anniversaryDate = json['anniversary_date'];
    categoryId = json['category_id'];
    countryCode = json['country_code'];
    deviceUuid = json['device_uuid'];
    devicePhone = json['device_phone'];
    profileImg = json['profile_img'];
    profileStatus = json['profile_status'];
    liteReceivedMsgCount = json['lite_received_msg_count'];
    liteSentMsgCount = json['lite_sent_msg_count'];
    assistantContact = json['assistant_contact'] != null
        ? AssistantContact.fromJson(json['assistant_contact'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['phone'] = phone;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['company_name'] = companyName;
    data['job_title'] = jobTitle;
    data['email'] = email;
    data['date_of_birth'] = dateOfBirth;
    data['anniversary_date'] = anniversaryDate;
    data['category_id'] = categoryId;
    data['country_code'] = countryCode;
    data['device_uuid'] = deviceUuid;
    data['device_phone'] = devicePhone;
    data['profile_img'] = profileImg;
    data['profile_status'] = profileStatus;
    data['lite_received_msg_count'] = liteReceivedMsgCount;
    data['lite_sent_msg_count'] = liteSentMsgCount;
    if (assistantContact != null) {
      data['assistant_contact'] = assistantContact!.toJson();
    }
    return data;
  }
}

class AssistantContact {
  int? assistantId;
  int? contactId;
  String? threadId;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  String? startAt;
  String? startAtTimezone;
  List<dynamic>? fileIds;
  String? assistantName;
  String? assistantDesc;
  String? assistantAgentName;
  int? deviceId;

  AssistantContact(
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

  AssistantContact.fromJson(Map<String, dynamic> json) {
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